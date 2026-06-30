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
    const cy = h * 0.24;
    const ringRadius = w * 0.22;
    const seconds = now.getSeconds();

    if (this.style === ClockStyle.Minimal) {
      const hh = String(now.getHours()).padStart(2, '0');
      const mm = String(now.getMinutes()).padStart(2, '0');
      ctx.save();
      ctx.shadowColor = 'rgba(0, 0, 0, 0.35)';
      ctx.shadowBlur = 8;
      ctx.shadowOffsetX = 1;
      ctx.shadowOffsetY = 1;
      ctx.fillStyle = 'rgba(240, 235, 225, 0.85)';
      ctx.font = (w * 0.20).toString() + 'px serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(hh + ':' + mm, cx, cy);
      ctx.restore();
      return;
    }

    // 外环 — 暖白色（更淡）
    ctx.strokeStyle = 'rgba(240, 235, 225, 0.08)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.arc(cx, cy, ringRadius, 0, Math.PI * 2);
    ctx.stroke();

    // 12 小时刻度 — 12/3/6/9 稍大
    for (let i = 0; i < 12; i++) {
      const angle = (i * Math.PI * 2) / 12 - Math.PI / 2;
      const dotX = cx + Math.cos(angle) * ringRadius;
      const dotY = cy + Math.sin(angle) * ringRadius;
      const isCardinal = (i % 3 === 0);
      const dotR = isCardinal ? w * 0.010 : w * 0.005;
      ctx.fillStyle = isCardinal ? 'rgba(240, 235, 225, 0.50)' : 'rgba(240, 235, 225, 0.25)';
      ctx.beginPath();
      ctx.arc(dotX, dotY, dotR, 0, Math.PI * 2);
      ctx.fill();
    }

    // 秒针
    const secAngle = (seconds * Math.PI * 2) / 60 - Math.PI / 2;
    const secLen = ringRadius * 0.82;
    ctx.strokeStyle = 'rgba(229, 115, 115, 0.45)';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(cx + Math.cos(secAngle) * secLen, cy + Math.sin(secAngle) * secLen);
    ctx.stroke();

    // 中心点
    ctx.fillStyle = 'rgba(240, 235, 225, 0.35)';
    ctx.beginPath();
    ctx.arc(cx, cy, w * 0.008, 0, Math.PI * 2);
    ctx.fill();

    // 时间文字 — 大号居中
    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const ss = String(seconds).padStart(2, '0');

    ctx.save();
    ctx.shadowColor = 'rgba(0, 0, 0, 0.5)';
    ctx.shadowBlur = 8;
    ctx.shadowOffsetX = 1;
    ctx.shadowOffsetY = 2;

    ctx.fillStyle = 'rgba(240, 235, 225, 0.95)';
    ctx.font = 'bold ' + (w * 0.20).toString() + 'px serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(hh + ':' + mm, cx, cy - w * 0.03);

    ctx.fillStyle = 'rgba(240, 235, 225, 0.45)';
    ctx.font = (w * 0.06).toString() + 'px serif';
    ctx.fillText(ss, cx, cy + w * 0.10);
    ctx.restore();

    // 日期 — 底部
    const year = now.getFullYear();
    const mon = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const wdays: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

    ctx.save();
    ctx.fillStyle = 'rgba(240, 235, 225, 0.45)';
    ctx.font = (w * 0.038).toString() + 'px serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    const dateText = year + '/' + mon + '/' + day + ' ' + wdays[now.getDay()];
    ctx.fillText(dateText, cx, h * 0.88);

    const tw = ctx.measureText(dateText).width;
    ctx.strokeStyle = 'rgba(229, 115, 115, 0.20)';
    ctx.lineWidth = 0.6;
    ctx.beginPath();
    ctx.moveTo(cx - tw * 0.45, h * 0.88 + w * 0.025);
    ctx.lineTo(cx + tw * 0.45, h * 0.88 + w * 0.025);
    ctx.stroke();
    ctx.restore();
  }
}
