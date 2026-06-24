import { ClockStyle } from '../Settings';

export class ClockLayer {
  private style: ClockStyle = ClockStyle.Digital;

  constructor() {
  }

  setStyle(s: ClockStyle): void {
    this.style = s;
  }

  draw(ctx: CanvasRenderingContext2D, w: number, h: number): void {
    if (this.style === ClockStyle.Hidden) {
      return;
    }

    const now = new Date();
    const cx = w / 2;
    const cy = h * 0.22;
    const ringRadius = w * 0.18;

    if (this.style === ClockStyle.Minimal) {
      const hh = String(now.getHours()).padStart(2, '0');
      const mm = String(now.getMinutes()).padStart(2, '0');
      ctx.fillStyle = 'rgba(255, 255, 255, 0.85)';
      ctx.font = (w * 0.10).toString() + 'px sans-serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(hh + ':' + mm, cx, cy);
      return;
    }

    ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.arc(cx, cy, ringRadius, 0, Math.PI * 2);
    ctx.stroke();

    for (let i = 0; i < 12; i++) {
      const angle = (i * Math.PI * 2) / 12 - Math.PI / 2;
      const dotX = cx + Math.cos(angle) * ringRadius;
      const dotY = cy + Math.sin(angle) * ringRadius;
      ctx.fillStyle = 'rgba(255, 255, 255, 0.5)';
      ctx.beginPath();
      ctx.arc(dotX, dotY, w * 0.005, 0, Math.PI * 2);
      ctx.fill();
    }

    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const ss = String(now.getSeconds()).padStart(2, '0');

    ctx.fillStyle = 'rgba(255, 255, 255, 0.95)';
    ctx.font = 'bold ' + (w * 0.11).toString() + 'px sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(hh + ':' + mm, cx, cy - w * 0.02);

    ctx.fillStyle = 'rgba(255, 255, 255, 0.6)';
    ctx.font = (w * 0.04).toString() + 'px sans-serif';
    ctx.fillText(ss, cx, cy + w * 0.06);

    const year = now.getFullYear();
    const mon = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const wdays: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

    ctx.fillStyle = 'rgba(255, 255, 255, 0.7)';
    ctx.font = (w * 0.035).toString() + 'px sans-serif';
    ctx.fillText(year + '/' + mon + '/' + day + ' ' + wdays[now.getDay()], cx, h * 0.88);
  }
}
