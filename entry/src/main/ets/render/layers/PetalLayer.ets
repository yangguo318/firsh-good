import { PetalState } from '../../model/PetalModel';
import { PetalDensity } from '../Settings';

export class PetalLayer {
  private density: PetalDensity = PetalDensity.Normal;
  private petals: PetalState[] = [];
  private readonly colors: string[] = ['rgba(255,183,197,', 'rgba(255,192,203,', 'rgba(255,228,225,'];

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
      p.size = 1 + (i % 3) * 0.2;
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
      const rot = frame * 0.015 + i * 1.2;
      const alpha = 0.6 + Math.sin(phase * 0.8) * 0.2;
      const colorIdx = p.type;
      const sz = w * 0.025 * p.size;

      ctx.save();
      ctx.translate(baseX, baseY);
      ctx.rotate(rot);
      ctx.fillStyle = this.colors[colorIdx] + alpha.toString() + ')';

      for (let j = 0; j < 5; j++) {
        const angle = (j * Math.PI * 2) / 5;
        const px = Math.cos(angle) * sz * 0.4;
        const py = Math.sin(angle) * sz * 0.4;
        ctx.beginPath();
        ctx.ellipse(px, py, sz * 0.35, sz * 0.2, angle, 0, Math.PI * 2);
        ctx.fill();
      }

      ctx.fillStyle = 'rgba(255, 200, 150, ' + (alpha * 0.8).toString() + ')';
      ctx.beginPath();
      ctx.arc(0, 0, sz * 0.15, 0, Math.PI * 2);
      ctx.fill();

      ctx.restore();
    }
  }
}
