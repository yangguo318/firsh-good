export class BackgroundLayer {
  draw(ctx: CanvasRenderingContext2D, w: number, h: number): void {
    const midY = h * 0.45;

    // 天空渐变 — 水墨色调
    const skyGrad = ctx.createLinearGradient(0, 0, 0, midY);
    skyGrad.addColorStop(0, '#1a2a3a');
    skyGrad.addColorStop(0.4, '#2c3e50');
    skyGrad.addColorStop(0.75, '#546e7a');
    skyGrad.addColorStop(1, '#7a8f99');
    ctx.fillStyle = skyGrad;
    ctx.fillRect(0, 0, w, midY);

    // 水面渐变 — 深翠到近黑
    const waterGrad = ctx.createLinearGradient(0, midY, 0, h);
    waterGrad.addColorStop(0, '#1b4332');
    waterGrad.addColorStop(0.3, '#163a2a');
    waterGrad.addColorStop(0.7, '#102d20');
    waterGrad.addColorStop(1, '#0a1f15');
    ctx.fillStyle = waterGrad;
    ctx.fillRect(0, midY, w, h - midY);

    // 月光/暖光 — 柔和径向渐变
    const sunX = w * 0.72;
    const sunY = h * 0.13;
    const sunR = w * 0.14;
    const sunGrad = ctx.createRadialGradient(sunX, sunY, 0, sunX, sunY, sunR);
    sunGrad.addColorStop(0, 'rgba(255, 230, 180, 0.25)');
    sunGrad.addColorStop(0.4, 'rgba(255, 220, 160, 0.12)');
    sunGrad.addColorStop(1, 'rgba(255, 210, 140, 0)');
    ctx.fillStyle = sunGrad;
    ctx.beginPath();
    ctx.arc(sunX, sunY, sunR, 0, Math.PI * 2);
    ctx.fill();

    // 雾气带 — 天水分界
    const mistGrad = ctx.createLinearGradient(0, midY - h * 0.04, 0, midY + h * 0.04);
    mistGrad.addColorStop(0, 'rgba(120, 140, 150, 0)');
    mistGrad.addColorStop(0.5, 'rgba(120, 140, 150, 0.15)');
    mistGrad.addColorStop(1, 'rgba(120, 140, 150, 0)');
    ctx.fillStyle = mistGrad;
    ctx.fillRect(0, midY - h * 0.04, w, h * 0.08);

    // 荷叶
    this.drawLotusLeaf(ctx, w * 0.16, h * 0.62, w * 0.08, 0.3);
    this.drawLotusLeaf(ctx, w * 0.76, h * 0.60, w * 0.07, -0.2);
    this.drawLotusLeaf(ctx, w * 0.40, h * 0.72, w * 0.09, 0.5);
    this.drawLotusLeaf(ctx, w * 0.82, h * 0.74, w * 0.065, -0.4);
    this.drawLotusLeaf(ctx, w * 0.25, h * 0.78, w * 0.06, 0.1);

    // 荷花阴影
    this.drawLotusShadow(ctx, w * 0.24, h * 0.58, w * 0.045);
    this.drawLotusShadow(ctx, w * 0.76, h * 0.57, w * 0.035);
    this.drawLotusShadow(ctx, w * 0.48, h * 0.68, w * 0.04);

    // 荷花
    this.drawLotusFlower(ctx, w * 0.24, h * 0.56, w * 0.042);
    this.drawLotusFlower(ctx, w * 0.76, h * 0.55, w * 0.033);
    this.drawLotusFlower(ctx, w * 0.48, h * 0.66, w * 0.037);

    // 暗角
    this.drawVignette(ctx, w, h);
  }

  private drawVignette(ctx: CanvasRenderingContext2D, w: number, h: number): void {
    const cx = w / 2;
    const cy = h / 2;
    const maxR = Math.sqrt(cx * cx + cy * cy);
    const vigGrad = ctx.createRadialGradient(cx, cy, maxR * 0.4, cx, cy, maxR);
    vigGrad.addColorStop(0, 'rgba(0, 0, 0, 0)');
    vigGrad.addColorStop(0.6, 'rgba(0, 0, 0, 0.05)');
    vigGrad.addColorStop(1, 'rgba(0, 0, 0, 0.45)');
    ctx.fillStyle = vigGrad;
    ctx.fillRect(0, 0, w, h);
  }

  private drawLotusShadow(ctx: CanvasRenderingContext2D, x: number, y: number, size: number): void {
    ctx.fillStyle = 'rgba(5, 15, 10, 0.25)';
    ctx.beginPath();
    ctx.ellipse(x + size * 0.05, y + size * 0.15, size * 1.1, size * 0.5, 0, 0, Math.PI * 2);
    ctx.fill();
  }

  private drawLotusLeaf(ctx: CanvasRenderingContext2D, x: number, y: number, r: number, rot: number): void {
    // 径向渐变填充
    const leafGrad = ctx.createRadialGradient(x - r * 0.2, y - r * 0.2, r * 0.1, x, y, r);
    leafGrad.addColorStop(0, 'rgba(56, 142, 60, 0.75)');
    leafGrad.addColorStop(0.6, 'rgba(46, 125, 50, 0.7)');
    leafGrad.addColorStop(1, 'rgba(27, 94, 32, 0.6)');
    ctx.fillStyle = leafGrad;

    // 带缺口的荷叶形状 — 小 V 形裂口
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rot);
    const notchHalf = 0.04 * Math.PI;
    ctx.beginPath();
    ctx.arc(0, 0, r, notchHalf, Math.PI * 2 - notchHalf);
    ctx.lineTo(Math.cos(notchHalf) * r * 0.06, Math.sin(notchHalf) * r * 0.06);
    ctx.lineTo(Math.cos(-notchHalf) * r * 0.06, Math.sin(-notchHalf) * r * 0.06);
    ctx.closePath();
    ctx.fill();

    // 叶脉 — 贝塞尔曲线
    ctx.strokeStyle = 'rgba(27, 94, 32, 0.35)';
    ctx.lineWidth = 0.8;
    for (let i = 0; i < 5; i++) {
      const a = (0.15 + i * 0.35) * Math.PI;
      ctx.beginPath();
      ctx.moveTo(0, 0);
      const ex = Math.cos(a) * r * 0.85;
      const ey = Math.sin(a) * r * 0.85;
      const cpx = ex * 0.5 + Math.sin(a + 0.3) * r * 0.15;
      const cpy = ey * 0.5 + Math.cos(a - 0.2) * r * 0.1;
      ctx.quadraticCurveTo(cpx, cpy, ex, ey);
      ctx.stroke();
    }
    ctx.restore();
  }

  private drawLotusFlower(ctx: CanvasRenderingContext2D, x: number, y: number, size: number): void {
    // 8 瓣，大小交替
    const petalColors = ['rgba(229, 115, 115, 0.85)', 'rgba(210, 100, 100, 0.8)'];
    for (let i = 0; i < 8; i++) {
      const a = (i * Math.PI * 2) / 8;
      const dist = size * 0.45 * (i % 2 === 0 ? 1.0 : 0.85);
      const pSize = size * 0.55 * (i % 2 === 0 ? 1.0 : 0.8);
      ctx.fillStyle = petalColors[i % 2];
      ctx.save();
      ctx.translate(x + Math.cos(a) * dist, y + Math.sin(a) * dist);
      ctx.rotate(a);
      ctx.scale(2.2, 1);
      ctx.beginPath();
      ctx.arc(0, 0, pSize * 0.4, 0, Math.PI * 2);
      ctx.restore();
      ctx.fill();
    }
    // 花心
    ctx.fillStyle = 'rgba(255, 220, 130, 0.9)';
    ctx.beginPath();
    ctx.arc(x, y, size * 0.28, 0, Math.PI * 2);
    ctx.fill();
    // 花心高光
    ctx.fillStyle = 'rgba(255, 240, 180, 0.6)';
    ctx.beginPath();
    ctx.arc(x - size * 0.05, y - size * 0.05, size * 0.12, 0, Math.PI * 2);
    ctx.fill();
  }
}
