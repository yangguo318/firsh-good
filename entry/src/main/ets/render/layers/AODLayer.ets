export class AODLayer {
  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    ctx.fillStyle = '#080808';
    ctx.fillRect(0, 0, w, h);

    const now = new Date();
    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const cx = w / 2;
    const cy = h / 2;

    const offsetX = Math.sin(frame * 0.08) * 2;
    const offsetY = Math.cos(frame * 0.08) * 2;

    // 圆环 — 暖暗色
    ctx.strokeStyle = 'rgba(200, 195, 185, 0.06)';
    ctx.lineWidth = 0.8;
    ctx.beginPath();
    ctx.arc(cx, cy, w * 0.20, 0, Math.PI * 2);
    ctx.stroke();

    // 时间 — 暖暗色 + 投影
    ctx.save();
    ctx.shadowColor = 'rgba(0, 0, 0, 0.5)';
    ctx.shadowBlur = 3;
    ctx.fillStyle = 'rgba(200, 195, 185, 0.35)';
    ctx.font = (w * 0.10).toString() + 'px serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(hh + ':' + mm, cx + offsetX, cy + offsetY);
    ctx.restore();
  }
}
