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
    { baseX: 0.22, baseY: 0.70, freqX: 0.010, freqY: 0.015, phase: 0, scale: 1.1, tailSpeed: 0.12 },
    { baseX: 0.72, baseY: 0.65, freqX: 0.008, freqY: 0.012, phase: 2.5, scale: 1.0, tailSpeed: 0.10 },
    { baseX: 0.45, baseY: 0.80, freqX: 0.007, freqY: 0.010, phase: 4.5, scale: 0.95, tailSpeed: 0.08 },
  ];

  constructor() {
    this.initFish();
  }

  setTheme(t: KoiTheme): void {
    this.theme = t;
  }

  private initFish(): void {
    const colors: string[] = ['#e8673a', '#d4a017', '#b71c3a'];
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
      return fishColor === '#e8673a';
    }
    if (this.theme === KoiTheme.Red) {
      return fishColor === '#b71c3a';
    }
    if (this.theme === KoiTheme.Gold) {
      return fishColor === '#d4a017';
    }
    return true;
  }

  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    const s = w * 0.15;

    for (let i = 0; i < 3; i++) {
      const f = this.fish[i];
      const cfg = this.fishConfigs[i];
      if (!this.isVisible(f.color)) {
        continue;
      }
      const fx = w * cfg.baseX + Math.sin(frame * cfg.freqX + cfg.phase) * w * 0.12;
      const fy = h * cfg.baseY + Math.sin(frame * cfg.freqY + cfg.phase * 0.6) * h * 0.025;
      const dir = Math.cos(frame * cfg.freqX + cfg.phase) > 0 ? 1 : -1;

      // 鱼影（先画，在鱼下方）
      this.drawFishShadow(ctx, fx, fy + s * cfg.scale * 0.08, s * cfg.scale * 0.45);

      // 水波涟漪
      this.drawRipple(ctx, fx, fy, s * cfg.scale * 0.5, frame);

      // 鱼体
      this.drawGoldfish(ctx, fx, fy, dir, f.color, frame * cfg.tailSpeed, s * cfg.scale, frame);
    }
  }

  private drawFishShadow(ctx: CanvasRenderingContext2D, x: number, y: number, size: number): void {
    ctx.fillStyle = 'rgba(5, 15, 10, 0.15)';
    ctx.beginPath();
    ctx.ellipse(x, y, size * 1.1, size * 0.35, 0, 0, Math.PI * 2);
    ctx.fill();
  }

  private drawRipple(ctx: CanvasRenderingContext2D, x: number, y: number, size: number, frame: number): void {
    const ripplePhase = (frame * 0.04) % 1;
    const rippleAlpha = 0.12 * (1 - ripplePhase);
    ctx.strokeStyle = `rgba(180, 210, 195, ${rippleAlpha.toFixed(2)})`;
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.ellipse(x, y + size * 0.2, size * (0.4 + ripplePhase * 0.25), size * 0.12 * (1 + ripplePhase * 0.15), 0, 0, Math.PI * 2);
    ctx.stroke();
  }

  private drawGoldfish(ctx: CanvasRenderingContext2D, x: number, y: number, dir: number, color: string, tailPhase: number, s: number, frame: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.scale(dir, 1);

    // 鱼身 — 水平+垂直双色渐变（背部深、腹部浅）
    const bodyGrad = ctx.createLinearGradient(0, -s * 0.28, 0, s * 0.28);
    bodyGrad.addColorStop(0, this.darkenColor(color, 20));
    bodyGrad.addColorStop(0.3, color);
    bodyGrad.addColorStop(0.7, this.lightenColor(color, 25));
    bodyGrad.addColorStop(1, this.lightenColor(color, 45));
    ctx.fillStyle = bodyGrad;
    ctx.beginPath();
    this.drawEllipse(ctx, 0, 0, s * 0.45, s * 0.28);
    ctx.fill();

    // 尾鳍
    const swing = Math.sin(tailPhase) * s * 0.18;
    const tailGrad = ctx.createLinearGradient(-s * 0.38, 0, -s * 0.75, 0);
    tailGrad.addColorStop(0, color);
    tailGrad.addColorStop(1, this.lightenColor(color, 15));
    ctx.fillStyle = tailGrad;
    ctx.beginPath();
    ctx.moveTo(-s * 0.38, 0);
    ctx.quadraticCurveTo(-s * 0.55, swing - s * 0.05, -s * 0.75, swing - s * 0.15);
    ctx.lineTo(-s * 0.70, swing - s * 0.05);
    ctx.lineTo(-s * 0.75, swing + s * 0.05);
    ctx.lineTo(-s * 0.70, swing + s * 0.10);
    ctx.quadraticCurveTo(-s * 0.55, swing + s * 0.05, -s * 0.38, 0);
    ctx.closePath();
    ctx.fill();

    // 背鳍
    ctx.fillStyle = color;
    ctx.globalAlpha = 0.55;
    ctx.beginPath();
    this.drawRotatedEllipse(ctx, -s * 0.08, -s * 0.26, s * 0.16, s * 0.09, -0.25);
    ctx.fill();
    ctx.beginPath();
    this.drawRotatedEllipse(ctx, s * 0.06, -s * 0.23, s * 0.13, s * 0.07, 0.2);
    ctx.fill();

    // 胸鳍 — 头部两侧小弧形
    ctx.globalAlpha = 0.45;
    ctx.beginPath();
    ctx.moveTo(s * 0.15, s * 0.05);
    ctx.quadraticCurveTo(s * 0.25, s * 0.18, s * 0.10, s * 0.22);
    ctx.quadraticCurveTo(s * 0.05, s * 0.15, s * 0.15, s * 0.05);
    ctx.closePath();
    ctx.fill();
    ctx.globalAlpha = 1;

    // 眼睛 — 虹膜环 + 高光
    ctx.fillStyle = '#1a1a1a';
    ctx.beginPath();
    ctx.arc(s * 0.28, -s * 0.06, s * 0.055, 0, Math.PI * 2);
    ctx.fill();
    // 虹膜
    ctx.fillStyle = this.lightenColor(color, 60);
    ctx.beginPath();
    ctx.arc(s * 0.28, -s * 0.06, s * 0.035, 0, Math.PI * 2);
    ctx.fill();
    // 瞳孔
    ctx.fillStyle = '#111';
    ctx.beginPath();
    ctx.arc(s * 0.29, -s * 0.06, s * 0.018, 0, Math.PI * 2);
    ctx.fill();
    // 高光
    ctx.fillStyle = 'rgba(255, 255, 255, 0.75)';
    ctx.beginPath();
    ctx.arc(s * 0.30, -s * 0.075, s * 0.015, 0, Math.PI * 2);
    ctx.fill();

    // 鳞片 — 闪烁效果
    const shimmer = 0.12 + Math.sin(frame * 0.03) * 0.06;
    ctx.strokeStyle = `rgba(255, 255, 255, ${shimmer.toFixed(2)})`;
    ctx.lineWidth = 0.7;
    for (let i = 0; i < 4; i++) {
      ctx.beginPath();
      ctx.arc(-s * 0.12 + i * s * 0.11, 0, s * 0.10, -0.5, 0.5);
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

  private darkenColor(color: string, amount: number): string {
    const hex = color.replace('#', '');
    const r = Math.max(0, parseInt(hex.substring(0, 2), 16) - amount);
    const g = Math.max(0, parseInt(hex.substring(2, 4), 16) - amount);
    const b = Math.max(0, parseInt(hex.substring(4, 6), 16) - amount);
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
    ctx.beginPath();
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }
}
