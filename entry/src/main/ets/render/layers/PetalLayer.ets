import { PetalState } from '../../model/PetalModel';
import { PetalDensity } from '../Settings';

export class PetalLayer {
  private density: PetalDensity = PetalDensity.Normal;
  private petals: PetalState[] = [];
  private readonly colors: string[] = ['rgba(229, 115, 115,', 'rgba(206, 147, 216,', 'rgba(188, 170, 164,'];

  constructor() {
    this.initPetals();
  }

  setDensity(d: PetalDensity): void {
    this.density = d;
  }

  private getCount(): number {
    if (this.density === PetalDensity.Sparse) {
      return 6;
    } else if (this.density === PetalDensity.Dense) {
      return 16;
    }
    return 10;
  }

  private initPetals(): void {
    for (let i = 0; i < 16; i++) {
      const p = new PetalState();
      p.type = i % 3;
      p.size = 0.6 + (i % 5) * 0.2;
      p.phase = i * 2.1;
      this.petals.push(p);
    }
  }

  draw(ctx: CanvasRenderingContext2D, w: number, h: number, frame: number): void {
    const count = this.getCount();

    for (let i = 0; i < count; i++) {
      const p = this.petals[i];
      const phase = frame * 0.006 + p.phase;
      const baseY = ((phase * 25 + i * 50) % (h * 1.3)) - h * 0.15;
      const baseX = w * (0.08 + (i * 0.19) % 0.84) + Math.sin(phase * 1.5) * w * 0.05;
      const rot = frame * 0.012 + i * 1.2;
      const alpha = 0.55 + Math.sin(phase * 0.8) * 0.2;
      const colorIdx = p.type;
      const sz = w * 0.025 * p.size;
      const rx = sz * 0.35;
      const ry = sz * 0.2;

      // 花瓣投影
      ctx.fillStyle = 'rgba(5, 15, 10, 0.1)';
      ctx.save();
      ctx.translate(baseX + 1, baseY + 1.5);
      ctx.rotate(rot);
      for (let j = 0; j < 5; j++) {
        const angle = (j * Math.PI * 2) / 5;
        const px = Math.cos(angle) * sz * 0.4;
        const py = Math.sin(angle) * sz * 0.4;
        this.drawPetal(ctx, px, py, rx, ry, angle);
      }
      ctx.restore();

      // 花瓣本体
      ctx.fillStyle = this.colors[colorIdx] + alpha.toFixed(2) + ')';
      ctx.save();
      ctx.translate(baseX, baseY);
      ctx.rotate(rot);

      for (let j = 0; j < 5; j++) {
        const angle = (j * Math.PI * 2) / 5;
        const px = Math.cos(angle) * sz * 0.4;
        const py = Math.sin(angle) * sz * 0.4;
        this.drawPetal(ctx, px, py, rx, ry, angle);
      }
      ctx.restore();

      // 花心
      ctx.fillStyle = 'rgba(200, 180, 150, ' + (alpha * 0.7).toFixed(2) + ')';
      ctx.beginPath();
      ctx.arc(baseX, baseY, sz * 0.12, 0, Math.PI * 2);
      ctx.fill();
    }
  }

  private drawPetal(ctx: CanvasRenderingContext2D, x: number, y: number, rx: number, ry: number, rot: number): void {
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(rot);
    ctx.scale(rx / ry, 1);
    ctx.beginPath();
    ctx.arc(0, 0, ry, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
  }
}
