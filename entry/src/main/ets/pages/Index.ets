import display from '@ohos.display';

interface FishState {
  x: number;
  y: number;
  dir: number;
  angle: number;
}

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  private W: number = 466;
  private H: number = 466;

  private fishA: FishState = { x: 0, y: 0, dir: 1, angle: 0 };
  private fishB: FishState = { x: 0, y: 0, dir: -1, angle: 0 };
  private fishC: FishState = { x: 0, y: 0, dir: 1, angle: 0 };

  private timer: number = 0;

  aboutToAppear() {
    try {
      const disp = display.getDefaultDisplaySync();
      this.W = disp.width;
      this.H = disp.height;
    } catch (e) {
      // fallback to default 466x466
    }

    this.fishA.x = this.W * 0.214;
    this.fishA.y = this.H * 0.599;
    this.fishB.x = this.W * 0.644;
    this.fishB.y = this.H * 0.429;
    this.fishC.x = this.W * 0.429;
    this.fishC.y = this.H * 0.687;

    this.timer = setInterval(() => {
      this.updateFishPositions();
      this.renderFrame();
    }, 50);
  }

  aboutToDisappear() {
    if (this.timer) clearInterval(this.timer);
  }

  renderFrame() {
    const c = this.ctx;
    const w = this.W;
    const h = this.H;
    c.clearRect(0, 0, w, h);

    const midY = h * 0.48;

    // 天空渐变
    const skyGrad = c.createLinearGradient(0, 0, 0, midY);
    skyGrad.addColorStop(0, '#0d1b2a');
    skyGrad.addColorStop(0.7, '#1b3a4b');
    skyGrad.addColorStop(1, '#2d4a3a');
    c.fillStyle = skyGrad;
    c.fillRect(0, 0, w, midY);

    // 水面渐变
    const waterGrad = c.createLinearGradient(0, midY, 0, h);
    waterGrad.addColorStop(0, '#1a3a4a');
    waterGrad.addColorStop(0.5, '#12303d');
    waterGrad.addColorStop(1, '#0a1a28');
    c.fillStyle = waterGrad;
    c.fillRect(0, midY, w, h - midY);

    // 月亮
    c.fillStyle = 'rgba(255, 250, 220, 0.15)';
    c.beginPath();
    c.arc(w * 0.79, h * 0.13, w * 0.066, 0, Math.PI * 2);
    c.fill();
    c.fillStyle = 'rgba(255, 250, 220, 0.08)';
    c.beginPath();
    c.arc(w * 0.79, h * 0.13, w * 0.099, 0, Math.PI * 2);
    c.fill();

    // 远山
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

    // 曲桥
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

    // 垂柳
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

    // 荷叶
    this.drawLotusLeaf(c, w * 0.22, h * 0.56, w * 0.066);
    this.drawLotusLeaf(c, w * 0.70, h * 0.59, w * 0.055);
    this.drawLotusLeaf(c, w * 0.44, h * 0.66, w * 0.077);
    this.drawLotusLeaf(c, w * 0.81, h * 0.70, w * 0.062);
    this.drawLotusLeaf(c, w * 0.33, h * 0.72, w * 0.048);
    this.drawLotusLeaf(c, w * 0.62, h * 0.74, w * 0.057);

    // 荷花
    this.drawLotusFlower(c, w * 0.29, h * 0.51, w * 0.031);
    this.drawLotusFlower(c, w * 0.75, h * 0.54, w * 0.024);
    this.drawLotusFlower(c, w * 0.51, h * 0.62, w * 0.026);

    // 水面波纹
    c.strokeStyle = 'rgba(120, 200, 220, 0.15)';
    c.lineWidth = 0.5;
    for (let i = 0; i < 6; i++) {
      c.beginPath();
      c.arc(w * 0.13 + i * w * 0.143, h * 0.79 + (i % 3) * h * 0.044, w * 0.033 + i * w * 0.007, 0, Math.PI * 2);
      c.stroke();
    }
    c.fillStyle = 'rgba(180, 220, 240, 0.05)';
    for (let i = 0; i < 10; i++) {
      c.beginPath();
      c.arc(w * 0.11 + i * w * 0.088, h * 0.62 + (i % 3) * h * 0.088, w * 0.007, 0, Math.PI * 2);
      c.fill();
    }

    // 金鱼
    const s = w * 0.040;
    this.drawGoldfish(c, this.fishA.x, this.fishA.y, this.fishA.dir, '#ff6b35', this.fishA.angle * 3, s);
    this.drawGoldfish(c, this.fishB.x, this.fishB.y, this.fishB.dir, '#ffa500', this.fishB.angle * 3, s * 0.9);
    this.drawGoldfish(c, this.fishC.x, this.fishC.y, this.fishC.dir, '#dc143c', this.fishC.angle * 3, s * 0.85);

    // 时钟
    this.drawClock(c, w, h);
  }

  drawLotusLeaf(ctx: CanvasRenderingContext2D, x: number, y: number, r: number) {
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

  drawEllipse(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number) {
    ctx.save();
    ctx.translate(x, y);
    ctx.scale(rx / ry, 1);
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }

  drawRotatedEllipse(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number, rot: number) {
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rot);
    ctx.scale(rx / ry, 1);
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.restore();
  }

  drawLotusFlower(ctx: CanvasRenderingContext2D, x: number, y: number, size: number) {
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

  updateFishPositions() {
    const w = this.W;
    const h = this.H;
    this.fishA.x += this.fishA.dir * w * 0.0026;
    this.fishA.y += Math.sin(this.fishA.angle) * h * 0.0011;
    this.fishA.angle += 0.05;
    if (this.fishA.x > w * 0.83 || this.fishA.x < w * 0.13) this.fishA.dir *= -1;

    this.fishB.x += this.fishB.dir * w * 0.0020;
    this.fishB.y += Math.sin(this.fishB.angle) * h * 0.0009;
    this.fishB.angle += 0.04;
    if (this.fishB.x > w * 0.79 || this.fishB.x < w * 0.18) this.fishB.dir *= -1;

    this.fishC.x += this.fishC.dir * w * 0.0015;
    this.fishC.y += Math.sin(this.fishC.angle) * h * 0.0007;
    this.fishC.angle += 0.03;
    if (this.fishC.x > w * 0.74 || this.fishC.x < w * 0.22) this.fishC.dir *= -1;
  }

  drawGoldfish(ctx: CanvasRenderingContext2D, x: number, y: number, dir: number, color: string, tailPhase: number, s: number) {
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

  drawClock(ctx: CanvasRenderingContext2D, w: number, h: number) {
    const now = new Date();
    const cx = w / 2;
    const cy = h / 2;
    const r = Math.min(w, h) * 0.24;

    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const ss = String(now.getSeconds()).padStart(2, '0');
    ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
    ctx.font = `${w * 0.079}px sans-serif`;
    ctx.textAlign = 'center';
    ctx.fillText(`${hh}:${mm}:${ss}`, cx, h * 0.26);

    const year = now.getFullYear();
    const mon = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const wdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    ctx.fillStyle = 'rgba(255, 255, 255, 0.6)';
    ctx.font = `${w * 0.035}px sans-serif`;
    ctx.fillText(`${year}年${mon}月${day}日 ${wdays[now.getDay()]}`, cx, h * 0.86);

    const secA = (now.getSeconds() / 60) * 360 - 90;
    const minA = ((now.getMinutes() + now.getSeconds() / 60) / 60) * 360 - 90;
    const hrA = ((now.getHours() % 12 + now.getMinutes() / 60) / 12) * 360 - 90;

    this.drawHand(ctx, cx, cy, hrA, r * 0.63, w * 0.011, 'rgba(255, 255, 255, 0.9)');
    this.drawHand(ctx, cx, cy, minA, r * 0.89, w * 0.007, 'rgba(255, 255, 255, 0.85)');
    this.drawHand(ctx, cx, cy, secA, r * 1.0, w * 0.003, '#e85d4a');

    ctx.fillStyle = '#e85d4a';
    ctx.beginPath();
    ctx.arc(cx, cy, w * 0.009, 0, Math.PI * 2);
    ctx.fill();

    for (let i = 0; i < 12; i++) {
      const a = (i * 30 - 90) * Math.PI / 180;
      const inner = i % 3 === 0 ? r * 1.05 : r * 1.10;
      ctx.strokeStyle = i % 3 === 0 ? 'rgba(255,255,255,0.8)' : 'rgba(255,255,255,0.5)';
      ctx.lineWidth = i % 3 === 0 ? 2 : 1;
      ctx.beginPath();
      ctx.moveTo(cx + Math.cos(a) * inner, cy + Math.sin(a) * inner);
      ctx.lineTo(cx + Math.cos(a) * r * 1.16, cy + Math.sin(a) * r * 1.16);
      ctx.stroke();
    }
  }

  drawHand(ctx: CanvasRenderingContext2D, cx: number, cy: number, angle: number, len: number, w: number, color: string) {
    const rad = (angle * Math.PI) / 180;
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(cx + len * Math.cos(rad), cy + len * Math.sin(rad));
    ctx.strokeStyle = color;
    ctx.lineWidth = w;
    ctx.lineCap = 'round';
    ctx.stroke();
  }

  build() {
    Canvas(this.ctx)
      .width('100%')
      .height('100%')
      .backgroundColor('#0a1628')
  }
}
