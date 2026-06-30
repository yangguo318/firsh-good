export class WaterSurfaceLayer {
  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    // 荷叶阴影（与水波纹叠加）
    this.drawLotusWaterShadow(ctx, w * 0.16, h * 0.62, w * 0.085);
    this.drawLotusWaterShadow(ctx, w * 0.40, h * 0.72, w * 0.095);
    this.drawLotusWaterShadow(ctx, w * 0.76, h * 0.60, w * 0.075);

    // 波纹环 — 柔和青绿色，透明度闪烁
    for (let i = 0; i < 6; i++) {
      const phase = frame * 0.012 + i * 1.1;
      const alpha = 0.08 + Math.sin(phase) * 0.04;
      const offsetX = Math.sin(frame * 0.010 + i * 0.9) * w * 0.012;
      const offsetY = Math.cos(frame * 0.008 + i * 0.7) * h * 0.006;
      ctx.strokeStyle = `rgba(160, 200, 180, ${alpha.toFixed(2)})`;
      ctx.lineWidth = 0.8;
      ctx.beginPath();
      ctx.arc(
        w * 0.12 + i * w * 0.14 + offsetX,
        h * 0.72 + (i % 3) * h * 0.06 + offsetY,
        w * 0.020 + i * w * 0.004,
        0, Math.PI * 2
      );
      ctx.stroke();
    }

    // 水光 caustics — 细密闪烁网格
    const causticAlpha = 0.035 + Math.sin(frame * 0.025) * 0.015;
    ctx.fillStyle = `rgba(220, 240, 230, ${causticAlpha.toFixed(3)})`;
    for (let gy = 0; gy < 8; gy++) {
      for (let gx = 0; gx < 10; gx++) {
        const bx = w * 0.06 + gx * w * 0.10;
        const by = h * 0.58 + gy * h * 0.055;
        const ox = Math.sin(frame * 0.018 + gx * 1.3 + gy * 0.7) * w * 0.015;
        const oy = Math.cos(frame * 0.022 + gx * 0.9 + gy * 1.1) * h * 0.008;
        const ca = causticAlpha * (0.5 + 0.5 * Math.sin(frame * 0.03 + gx + gy));
        ctx.fillStyle = `rgba(220, 240, 230, ${ca.toFixed(3)})`;
        ctx.beginPath();
        ctx.arc(bx + ox, by + oy, w * 0.006, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    // 光斑 — 较大柔和亮点
    for (let i = 0; i < 8; i++) {
      const phase = frame * 0.015 + i * 0.9;
      const alpha = 0.06 + Math.sin(phase) * 0.03;
      const offsetY = Math.sin(frame * 0.012 + i * 0.8) * h * 0.012;
      ctx.fillStyle = `rgba(200, 230, 210, ${alpha.toFixed(2)})`;
      ctx.beginPath();
      ctx.arc(
        w * 0.10 + i * w * 0.11,
        h * 0.62 + (i % 4) * h * 0.07 + offsetY,
        w * 0.012,
        0, Math.PI * 2
      );
      ctx.fill();
    }
  }

  private drawLotusWaterShadow(ctx: CanvasRenderingContext2D, x: number, y: number, r: number): void {
    ctx.fillStyle = 'rgba(5, 20, 12, 0.12)';
    ctx.beginPath();
    ctx.ellipse(x, y + r * 0.3, r * 1.2, r * 0.4, 0, 0, Math.PI * 2);
    ctx.fill();
  }
}
