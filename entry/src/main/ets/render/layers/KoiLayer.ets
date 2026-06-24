import { FishState } from '../../model/FishModel';
import { KoiTheme } from '../Settings';

interface FishConfig {
  baseX: number;
  baseY: number;
  freqX: number;
  freqY: number;
  phase: number;
  scale: number;
  tailSpeed: number;
}

export class KoiLayer {
  private theme: KoiTheme = KoiTheme.Mixed;
  private fish: FishState[] = [];
  private readonly fishConfigs: FishConfig[] = [
    { baseX: 0.25, baseY: 0.60, freqX: 0.010, freqY: 0.018, phase: 0, scale: 1.0, tailSpeed: 0.12 },
    { baseX: 0.65, baseY: 0.45, freqX: 0.008, freqY: 0.015, phase: 2.5, scale: 0.9, tailSpeed: 0.10 },
    { baseX: 0.45, baseY: 0.72, freqX: 0.007, freqY: 0.013, phase: 4.5, scale: 0.85, tailSpeed: 0.08 },
  ];

  constructor() {
    this.initFish();
  }

  setTheme(t: KoiTheme): void {
    this.theme = t;
  }

  private initFish(): void {
    const colors: string[] = ['#ff6b35', '#ffa500', '#dc143c'];
    for (let i = 0; i < 3; i++) {
      const f = new FishState();
      f.color = colors[i];
      f.size = this.fishConfigs[i].scale;
      this.fish.push(f);
    }
  }

  private isVisible(fishColor: string): boolean {
    if (this.theme === KoiTheme.Mixed) {
      return true;
    }
    if (this.theme === KoiTheme.Orange) {
      return fishColor === '#ff6b35';
    }
    if (this.theme === KoiTheme.Red) {
      return fishColor === '#dc143c';
    }
    if (this.theme === KoiTheme.Gold) {
      return fishColor === '#ffa500';
    }
    return true;
  }

  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    const s = w * 0.12;

    for (let i = 0; i < 3; i++) {
      const f = this.fish[i];
      const cfg = this.fishConfigs[i];
      if (!this.isVisible(f.color)) {
        continue;
      }
      const fx = w * cfg.baseX + Math.sin(frame * cfg.freqX + cfg.phase) * w * 0.20;
      const fy = h * cfg.baseY + Math.sin(frame * cfg.freqY + cfg.phase * 0.6) * h * 0.04;
      const dir = Math.cos(frame * cfg.freqX + cfg.phase) > 0 ? 1 : -1;
      this.drawGoldfish(ctx, fx, fy, dir, f.color, frame * cfg.tailSpeed, s * cfg.scale);
      this.drawRipple(ctx, fx, fy, s * cfg.scale * 0.6, frame);
    }
  }

  private drawRipple(ctx: CanvasRenderingContext2D, x: number, y: number, size: number, frame: number): void {
    const ripplePhase = (frame * 0.05) % 1;
    const rippleAlpha = 0.2 * (1 - ripplePhase);
    ctx.strokeStyle = 'rgba(255, 255, 255, ' + rippleAlpha.toString() + ')';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.ellipse(x, y + size * 0.3, size * (0.5 + ripplePhase * 0.3), size * 0.15 * (1 + ripplePhase * 0.2), 0, 0, Math.PI * 2);
    ctx.stroke();
  }

  private drawGoldfish(ctx: CanvasRenderingContext2D, x: number, y: number, dir: number, color: string, tailPhase: number, s: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.scale(dir, 1);

    const bodyGrad = ctx.createLinearGradient(-s * 0.4, 0, s * 0.4, 0);
    bodyGrad.addColorStop(0, color);
    bodyGrad.addColorStop(0.5, this.lightenColor(color, 30));
    bodyGrad.addColorStop(1, color);
    ctx.fillStyle = bodyGrad;
    ctx.beginPath();
    this.drawEllipse(ctx, 0, 0, s * 0.45, s * 0.28);
    ctx.fill();

    const swing = Math.sin(tailPhase) * s * 0.18;
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(-s * 0.38, 0);
    ctx.quadraticCurveTo(-s * 0.55, swing - s * 0.05, -s * 0.75, swing - s * 0.15);
    ctx.lineTo(-s * 0.70, swing - s * 0.05);
    ctx.lineTo(-s * 0.75, swing + s * 0.05);
    ctx.lineTo(-s * 0.70, swing + s * 0.10);
    ctx.quadraticCurveTo(-s * 0.55, swing + s * 0.05, -s * 0.38, 0);
    ctx.closePath();
    ctx.fill();

    ctx.fillStyle = color;
    ctx.globalAlpha = 0.6;
    ctx.beginPath();
    this.drawRotatedEllipse(ctx, -s * 0.10, -s * 0.25, s * 0.18, s * 0.10, -0.3);
    ctx.fill();
    ctx.beginPath();
    this.drawRotatedEllipse(ctx, s * 0.05, -s * 0.22, s * 0.15, s * 0.08, 0.2);
    ctx.fill();
    ctx.globalAlpha = 1;

    ctx.fillStyle = '#000';
    ctx.beginPath();
    ctx.arc(s * 0.28, -s * 0.08, s * 0.06, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = 'rgba(255,255,255,0.7)';
    ctx.beginPath();
    ctx.arc(s * 0.29, -s * 0.09, s * 0.025, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.lineWidth = 0.8;
    for (let i = 0; i < 4; i++) {
      ctx.beginPath();
      ctx.arc(-s * 0.15 + i * s * 0.12, 0, s * 0.12, -0.6, 0.6);
      ctx.stroke();
    }

    ctx.restore();
  }

  private lightenColor(color: string, amount: number): string {
    const hex = color.replace('#', '');
    const r = Math.min(255, parseInt(hex.substring(0, 2), 16) + amount);
    const g = Math.min(255, parseInt(hex.substring(2, 4), 16) + amount);
    const b = Math.min(255, parseInt(hex.substring(4, 6), 16) + amount);
    return '#' + r.toString(16).padStart(2, '0') + g.toString(16).padStart(2, '0') + b.toString(16).padStart(2, '0');
  }

  private drawEllipse(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.scale(rx / ry, 1);
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }

  private drawRotatedEllipse(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number, rot: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rot);
    ctx.scale(rx / ry, 1);
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }
}
