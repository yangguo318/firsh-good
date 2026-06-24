import display from '@ohos.display';

export enum DisplayMode {
  Normal = 0,
  AOD = 1
}

export enum ClockStyle {
  Digital = 0,
  Minimal = 1,
  Hidden = 2
}

export enum KoiTheme {
  Orange = 0,
  Red = 1,
  Gold = 2,
  Mixed = 3
}

export enum PetalDensity {
  Sparse = 0,
  Normal = 1,
  Dense = 2
}

export class RenderEngine {
  private ctx: CanvasRenderingContext2D | null = null;
  private W: number = 466;
  private H: number = 466;
  private timer: number = 0;
  private frameCount: number = 0;
  private displayMode: DisplayMode = DisplayMode.Normal;
  private clockStyle: ClockStyle = ClockStyle.Digital;
  private koiTheme: KoiTheme = KoiTheme.Mixed;
  private petalDensity: PetalDensity = PetalDensity.Normal;
  private bgReady: boolean = false;

  init(ctx: CanvasRenderingContext2D): void {
    this.ctx = ctx;
    try {
      const disp = display.getDefaultDisplaySync();
      this.W = disp.width;
      this.H = disp.height;
    } catch (e) {
    }
  }

  getW(): number {
    return this.W;
  }

  getH(): number {
    return this.H;
  }

  getFrameCount(): number {
    return this.frameCount;
  }

  getDisplayMode(): DisplayMode {
    return this.displayMode;
  }

  setDisplayMode(mode: DisplayMode): void {
    this.displayMode = mode;
  }

  getClockStyle(): ClockStyle {
    return this.clockStyle;
  }

  setClockStyle(style: ClockStyle): void {
    this.clockStyle = style;
  }

  getKoiTheme(): KoiTheme {
    return this.koiTheme;
  }

  setKoiTheme(theme: KoiTheme): void {
    this.koiTheme = theme;
  }

  getPetalDensity(): PetalDensity {
    return this.petalDensity;
  }

  setPetalDensity(density: PetalDensity): void {
    this.petalDensity = density;
  }

  start(): void {
    if (this.timer) {
      return;
    }
    this.timer = setInterval(() => {
      this.renderFrame();
    }, 50);
  }

  stop(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = 0;
    }
  }

  destroy(): void {
    this.stop();
    this.ctx = null;
    this.bgReady = false;
  }

  private renderFrame(): void {
    const c = this.ctx;
    if (!c) {
      return;
    }
    const w = this.W;
    const h = this.H;
    c.clearRect(0, 0, w, h);

    if (this.displayMode === DisplayMode.AOD) {
      this.drawAOD(c, w, h);
      return;
    }

    this.drawBackground(c, w, h);
    this.drawWaterSurface(c, w, h);
    this.drawPetals(c, w, h);
    this.drawKoi(c, w, h);
    this.drawClock(c, w, h);

    this.frameCount++;
  }

  private drawBackground(c: CanvasRenderingContext2D, w: number, h: number): void {
    const midY = h * 0.48;

    const skyGrad = c.createLinearGradient(0, 0, 0, midY);
    skyGrad.addColorStop(0, '#0d1b2a');
    skyGrad.addColorStop(0.7, '#1b3a4b');
    skyGrad.addColorStop(1, '#2d4a3a');
    c.fillStyle = skyGrad;
    c.fillRect(0, 0, w, midY);

    const waterGrad = c.createLinearGradient(0, midY, 0, h);
    waterGrad.addColorStop(0, '#1a3a4a');
    waterGrad.addColorStop(0.5, '#12303d');
    waterGrad.addColorStop(1, '#0a1a28');
    c.fillStyle = waterGrad;
    c.fillRect(0, midY, w, h - midY);

    c.fillStyle = 'rgba(255, 250, 220, 0.15)';
    c.beginPath();
    c.arc(w * 0.79, h * 0.13, w * 0.066, 0, Math.PI * 2);
    c.fill();
    c.fillStyle = 'rgba(255, 250, 220, 0.08)';
    c.beginPath();
    c.arc(w * 0.79, h * 0.13, w * 0.099, 0, Math.PI * 2);
    c.fill();

    c.fillStyle = 'rgba(40, 60, 80, 0.4)';
    c.beginPath();
    c.moveTo(0, midY - 10);
    c.quadraticCurveTo(w * 0.13, midY - 35, w * 0.29, midY - 22);
    c.quadraticCurveTo(w * 0.40, midY - 45, w * 0.53, midY - 28);
    c.quadraticCurveTo(w * 0.66, midY - 50, w * 0.81, midY - 30);
    c.quadraticCurveTo(w * 0.92, midY - 40, w, midY - 15);
    c.lineTo(w, midY);
    c.lineTo(0, midY);
    c.closePath();
    c.fill();

    c.fillStyle = 'rgba(30, 50, 60, 0.5)';
    c.beginPath();
    c.moveTo(0, midY + 5);
    c.quadraticCurveTo(w * 0.11, midY - 12, w * 0.24, midY + 2);
    c.quadraticCurveTo(w * 0.35, midY - 18, w * 0.48, midY - 2);
    c.quadraticCurveTo(w * 0.62, midY - 15, w * 0.77, midY);
    c.quadraticCurveTo(w * 0.90, midY - 10, w, midY + 5);
    c.lineTo(w, midY);
    c.lineTo(0, midY);
    c.closePath();
    c.fill();

    c.strokeStyle = 'rgba(80, 100, 90, 0.5)';
    c.lineWidth = 2;
    c.beginPath();
    c.moveTo(w * 0.11, midY);
    c.quadraticCurveTo(w * 0.26, midY - 22, w * 0.42, midY);
    c.stroke();
    c.strokeStyle = 'rgba(80, 100, 90, 0.3)';
    c.lineWidth = 1;
    for (let i = 0; i < 5; i++) {
      const bx = w * 0.145 + i * w * 0.055;
      const by = midY - Math.sin((bx - w * 0.11) / (w * 0.31) * Math.PI) * 22;
      c.beginPath();
      c.moveTo(bx, by);
      c.lineTo(bx, midY + 2);
      c.stroke();
    }

    c.strokeStyle = 'rgba(50, 80, 50, 0.5)';
    c.lineWidth = 2;
    c.beginPath();
    c.moveTo(w * 0.044, h * 0.22);
    c.quadraticCurveTo(w * 0.033, h * 0.31, w * 0.055, h * 0.42);
    c.stroke();
    c.strokeStyle = 'rgba(60, 100, 60, 0.4)';
    c.lineWidth = 1;
    for (let i = 0; i < 8; i++) {
      const sy = h * 0.265 + i * h * 0.018;
      c.beginPath();
      c.moveTo(w * 0.044, sy);
      c.quadraticCurveTo(w * 0.088 + i * w * 0.007, sy + h * 0.066, w * 0.066 + i * w * 0.011, sy + h * 0.12);
      c.stroke();
    }

    this.drawLotusLeaf(c, w * 0.22, h * 0.56, w * 0.066);
    this.drawLotusLeaf(c, w * 0.70, h * 0.59, w * 0.055);
    this.drawLotusLeaf(c, w * 0.44, h * 0.66, w * 0.077);
    this.drawLotusLeaf(c, w * 0.81, h * 0.70, w * 0.062);
    this.drawLotusLeaf(c, w * 0.33, h * 0.72, w * 0.048);
    this.drawLotusLeaf(c, w * 0.62, h * 0.74, w * 0.057);

    this.drawLotusFlower(c, w * 0.29, h * 0.51, w * 0.031);
    this.drawLotusFlower(c, w * 0.75, h * 0.54, w * 0.024);
    this.drawLotusFlower(c, w * 0.51, h * 0.62, w * 0.026);
  }

  private drawLotusLeaf(ctx: CanvasRenderingContext2D, x: number, y: number, r: number): void {
    ctx.fillStyle = 'rgba(40, 100, 60, 0.7)';
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.fill();
    ctx.strokeStyle = 'rgba(30, 70, 40, 0.5)';
    ctx.lineWidth = 1;
    for (let i = 0; i < 6; i++) {
      const a = (i * Math.PI) / 3;
      ctx.beginPath();
      ctx.moveTo(x, y);
      ctx.lineTo(x + Math.cos(a) * r, y + Math.sin(a) * r);
      ctx.stroke();
    }
  }

  private drawLotusFlower(ctx: CanvasRenderingContext2D, x: number, y: number, size: number): void {
    ctx.fillStyle = 'rgba(255, 180, 200, 0.8)';
    for (let i = 0; i < 5; i++) {
      const a = (i * Math.PI * 2) / 5;
      this.drawRotatedEllipse(ctx,
        x + Math.cos(a) * size * 0.5, y + Math.sin(a) * size * 0.5,
        size * 0.6, size * 0.3, a);
      ctx.fill();
    }
    ctx.fillStyle = 'rgba(255, 220, 100, 0.9)';
    ctx.beginPath();
    ctx.arc(x, y, size * 0.3, 0, Math.PI * 2);
    ctx.fill();
  }

  private drawRotatedEllipse(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number, rot: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rot);
    ctx.scale(rx / ry, 1);
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }

  private drawEllipse(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.scale(rx / ry, 1);
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }

  private drawWaterSurface(c: CanvasRenderingContext2D, w: number, h: number): void {
    const frame = this.frameCount;
    c.strokeStyle = 'rgba(120, 200, 220, 0.15)';
    c.lineWidth = 0.5;
    for (let i = 0; i < 6; i++) {
      const offsetX = Math.sin(frame * 0.02 + i) * w * 0.01;
      c.beginPath();
      c.arc(w * 0.13 + i * w * 0.143 + offsetX, h * 0.79 + (i % 3) * h * 0.044, w * 0.033 + i * w * 0.007, 0, Math.PI * 2);
      c.stroke();
    }
    c.fillStyle = 'rgba(180, 220, 240, 0.05)';
    for (let i = 0; i < 10; i++) {
      const offsetY = Math.sin(frame * 0.015 + i * 0.5) * h * 0.005;
      c.beginPath();
      c.arc(w * 0.11 + i * w * 0.088, h * 0.62 + (i % 3) * h * 0.088 + offsetY, w * 0.007, 0, Math.PI * 2);
      c.fill();
    }
  }

  private drawPetals(c: CanvasRenderingContext2D, w: number, h: number): void {
    const frame = this.frameCount;
    const count = this.getPetalCount();
    const colors: string[] = ['rgba(255,183,197,', 'rgba(255,240,245,', 'rgba(255,158,128,'];
    for (let i = 0; i < count; i++) {
      const phase = frame * 0.008 + i * 1.7;
      const baseY = ((phase * 30 + i * 60) % (h * 1.2)) - h * 0.1;
      const baseX = w * (0.1 + (i * 0.17) % 0.8) + Math.sin(phase * 2) * w * 0.03;
      const rot = frame * 0.02 + i;
      const alpha = 0.5 + Math.sin(phase) * 0.2;
      const colorIdx = i % 3;
      const sz = w * 0.012 + (i % 3) * w * 0.004;

      c.save();
      c.translate(baseX, baseY);
      c.rotate(rot);
      c.fillStyle = colors[colorIdx] + alpha.toString() + ')';
      c.beginPath();
      c.ellipse(0, 0, sz, sz * 0.5, 0, 0, Math.PI * 2);
      c.fill();
      c.restore();
    }
  }

  private getPetalCount(): number {
    if (this.petalDensity === PetalDensity.Sparse) {
      return 6;
    } else if (this.petalDensity === PetalDensity.Dense) {
      return 16;
    }
    return 10;
  }

  private drawKoi(c: CanvasRenderingContext2D, w: number, h: number): void {
    const frame = this.frameCount;
    const s = w * 0.040;

    const fishAx = w * 0.214 + Math.sin(frame * 0.013) * w * 0.25;
    const fishAy = h * 0.599 + Math.sin(frame * 0.025) * h * 0.04;
    const fishAdir = Math.cos(frame * 0.013) > 0 ? 1 : -1;
    this.drawGoldfish(c, fishAx, fishAy, fishAdir, '#ff6b35', frame * 0.15, s);

    const fishBx = w * 0.644 + Math.sin(frame * 0.010 + 2) * w * 0.20;
    const fishBy = h * 0.429 + Math.sin(frame * 0.020 + 1) * h * 0.03;
    const fishBdir = Math.cos(frame * 0.010 + 2) > 0 ? 1 : -1;
    this.drawGoldfish(c, fishBx, fishBy, fishBdir, '#ffa500', frame * 0.12, s * 0.9);

    const fishCx = w * 0.429 + Math.sin(frame * 0.008 + 4) * w * 0.18;
    const fishCy = h * 0.687 + Math.sin(frame * 0.015 + 2) * h * 0.025;
    const fishCdir = Math.cos(frame * 0.008 + 4) > 0 ? 1 : -1;
    this.drawGoldfish(c, fishCx, fishCy, fishCdir, '#dc143c', frame * 0.09, s * 0.85);
  }

  private drawGoldfish(ctx: CanvasRenderingContext2D, x: number, y: number, dir: number, color: string, tailPhase: number, s: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.scale(dir, 1);

    ctx.fillStyle = color;
    ctx.beginPath();
    this.drawEllipse(ctx, 0, 0, s * 0.44, s * 0.25);
    ctx.fill();

    const swing = Math.sin(tailPhase) * s * 0.15;
    ctx.beginPath();
    ctx.moveTo(-s * 0.37, 0);
    ctx.quadraticCurveTo(-s * 0.55, swing - s * 0.04, -s * 0.70, swing - s * 0.10);
    ctx.lineTo(-s * 0.65, swing);
    ctx.lineTo(-s * 0.70, swing + s * 0.10);
    ctx.quadraticCurveTo(-s * 0.55, swing + s * 0.04, -s * 0.37, 0);
    ctx.closePath();
    ctx.fill();

    ctx.fillStyle = '#000';
    ctx.beginPath();
    ctx.arc(s * 0.25, -s * 0.08, s * 0.05, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = 'rgba(255,255,255,0.6)';
    ctx.beginPath();
    ctx.arc(s * 0.26, -s * 0.09, s * 0.02, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = color;
    ctx.globalAlpha = 0.5;
    ctx.beginPath();
    this.drawRotatedEllipse(ctx, -s * 0.08, -s * 0.20, s * 0.15, s * 0.08, -0.3);
    ctx.fill();
    ctx.globalAlpha = 1;

    ctx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
    ctx.lineWidth = 0.5;
    for (let i = 0; i < 3; i++) {
      ctx.beginPath();
      ctx.arc(-s * 0.12 + i * s * 0.15, 0, s * 0.10, -0.5, 0.5);
      ctx.stroke();
    }
    ctx.restore();
  }

  private drawClock(c: CanvasRenderingContext2D, w: number, h: number): void {
    if (this.clockStyle === ClockStyle.Hidden) {
      return;
    }

    const now = new Date();
    const cx = w / 2;

    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');

    if (this.clockStyle === ClockStyle.Minimal) {
      c.fillStyle = 'rgba(255, 255, 255, 0.7)';
      c.font = (w * 0.10).toString() + 'px sans-serif';
      c.textAlign = 'center';
      c.fillText(hh + ':' + mm, cx, h * 0.26);
      return;
    }

    const ss = String(now.getSeconds()).padStart(2, '0');
    c.fillStyle = 'rgba(255, 255, 255, 0.9)';
    c.font = (w * 0.12).toString() + 'px sans-serif';
    c.textAlign = 'center';
    c.fillText(hh + ':' + mm + ':' + ss, cx, h * 0.26);

    const year = now.getFullYear();
    const mon = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const wdays: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    c.fillStyle = 'rgba(255, 255, 255, 0.6)';
    c.font = (w * 0.035).toString() + 'px sans-serif';
    c.fillText(year + '年' + mon + '月' + day + '日 ' + wdays[now.getDay()], cx, h * 0.86);
  }

  private drawAOD(c: CanvasRenderingContext2D, w: number, h: number): void {
    c.fillStyle = '#000000';
    c.fillRect(0, 0, w, h);

    const now = new Date();
    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const cx = w / 2;
    const cy = h / 2;

    const offsetX = Math.sin(this.frameCount * 0.1) * 2;
    const offsetY = Math.cos(this.frameCount * 0.1) * 2;

    c.fillStyle = 'rgba(255, 255, 255, 0.4)';
    c.font = (w * 0.10).toString() + 'px sans-serif';
    c.textAlign = 'center';
    c.fillText(hh + ':' + mm, cx + offsetX, cy + offsetY);

    this.frameCount++;
  }
}
