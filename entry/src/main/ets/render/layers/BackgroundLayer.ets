export class BackgroundLayer {
  draw(ctx: CanvasRenderingContext2D, w: number, h: number): void {
    const midY = h * 0.45;

    const skyGrad = ctx.createLinearGradient(0, 0, 0, midY);
    skyGrad.addColorStop(0, '#87CEEB');
    skyGrad.addColorStop(0.5, '#B0E0E6');
    skyGrad.addColorStop(1, '#E0F7FA');
    ctx.fillStyle = skyGrad;
    ctx.fillRect(0, 0, w, midY);

    const waterGrad = ctx.createLinearGradient(0, midY, 0, h);
    waterGrad.addColorStop(0, '#5FABA7');
    waterGrad.addColorStop(0.5, '#4A9B98');
    waterGrad.addColorStop(1, '#3D8B8B');
    ctx.fillStyle = waterGrad;
    ctx.fillRect(0, midY, w, h - midY);

    ctx.fillStyle = 'rgba(255, 255, 200, 0.3)';
    ctx.beginPath();
    ctx.arc(w * 0.75, h * 0.12, w * 0.06, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = 'rgba(255, 255, 220, 0.15)';
    ctx.beginPath();
    ctx.arc(w * 0.75, h * 0.12, w * 0.09, 0, Math.PI * 2);
    ctx.fill();

    this.drawLotusLeaf(ctx, w * 0.20, h * 0.55, w * 0.07);
    this.drawLotusLeaf(ctx, w * 0.72, h * 0.58, w * 0.06);
    this.drawLotusLeaf(ctx, w * 0.45, h * 0.68, w * 0.08);
    this.drawLotusLeaf(ctx, w * 0.82, h * 0.72, w * 0.065);
    this.drawLotusLeaf(ctx, w * 0.30, h * 0.75, w * 0.055);

    this.drawLotusFlower(ctx, w * 0.28, h * 0.50, w * 0.035);
    this.drawLotusFlower(ctx, w * 0.76, h * 0.53, w * 0.028);
    this.drawLotusFlower(ctx, w * 0.52, h * 0.63, w * 0.030);
  }

  private drawLotusLeaf(ctx: CanvasRenderingContext2D, x: number, y: number, r: number): void {
    ctx.fillStyle = 'rgba(80, 180, 100, 0.6)';
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = 'rgba(60, 140, 80, 0.4)';
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
    ctx.fillStyle = 'rgba(255, 150, 180, 0.9)';
    for (let i = 0; i < 5; i++) {
      const a = (i * Math.PI * 2) / 5;
      this.drawRotatedEllipse(ctx,
        x + Math.cos(a) * size * 0.5, y + Math.sin(a) * size * 0.5,
        size * 0.6, size * 0.3, a);
      ctx.fill();
    }
    ctx.fillStyle = 'rgba(255, 220, 100, 0.95)';
    ctx.beginPath();
    ctx.arc(x, y, size * 0.35, 0, Math.PI * 2);
    ctx.fill();
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
