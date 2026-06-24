export class WaterSurfaceLayer {
  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.25)';
    ctx.lineWidth = 1;
    for (let i = 0; i < 8; i++) {
      const offsetX = Math.sin(frame * 0.015 + i * 0.8) * w * 0.015;
      const offsetY = Math.cos(frame * 0.012 + i * 0.6) * h * 0.008;
      ctx.beginPath();
      ctx.arc(w * 0.10 + i * w * 0.12 + offsetX, h * 0.75 + (i % 3) * h * 0.05 + offsetY,
        w * 0.025 + i * w * 0.005, 0, Math.PI * 2);
      ctx.stroke();
    }

    ctx.fillStyle = 'rgba(255, 255, 255, 0.15)';
    for (let i = 0; i < 12; i++) {
      const offsetY = Math.sin(frame * 0.02 + i * 0.7) * h * 0.01;
      ctx.beginPath();
      ctx.arc(w * 0.08 + i * w * 0.08, h * 0.60 + (i % 4) * h * 0.08 + offsetY,
        w * 0.008, 0, Math.PI * 2);
      ctx.fill();
    }
  }
}
