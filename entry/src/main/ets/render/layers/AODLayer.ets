export class AODLayer {
  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    ctx.fillStyle = '#1a1a1a';
    ctx.fillRect(0, 0, w, h);

    const now = new Date();
    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const cx = w / 2;
    const cy = h / 2;

    const offsetX = Math.sin(frame * 0.08) * 2;
    const offsetY = Math.cos(frame * 0.08) * 2;

    ctx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.arc(cx, cy, w * 0.20, 0, Math.PI * 2);
    ctx.stroke();

    ctx.fillStyle = 'rgba(255, 255, 255, 0.5)';
    ctx.font = (w * 0.10).toString() + 'px sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(hh + ':' + mm, cx + offsetX, cy + offsetY);
  }
}
