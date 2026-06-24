import { ClockStyle, DisplayMode, KoiTheme, PetalDensity } from '../render/Settings';
import { RenderEngine } from '../render/RenderEngine';

export class InteractionManager {
  private engine: RenderEngine;

  constructor(engine: RenderEngine) {
    this.engine = engine;
  }

  onTap(): void {
    const current = this.engine.getClockStyle();
    if (current === ClockStyle.Digital) {
      this.engine.setClockStyle(ClockStyle.Minimal);
    } else if (current === ClockStyle.Minimal) {
      this.engine.setClockStyle(ClockStyle.Hidden);
    } else {
      this.engine.setClockStyle(ClockStyle.Digital);
    }
  }

  onRotaryClockwise(): void {
    const current = this.engine.getKoiTheme();
    const next = ((current as number) + 1) % 4;
    this.engine.setKoiTheme(next as KoiTheme);
  }

  onRotaryCounterClockwise(): void {
    const current = this.engine.getPetalDensity();
    const next = ((current as number) + 1) % 3;
    this.engine.setPetalDensity(next as PetalDensity);
  }

  toggleAOD(): void {
    const current = this.engine.getDisplayMode();
    if (current === DisplayMode.Normal) {
      this.engine.setDisplayMode(DisplayMode.AOD);
    } else {
      this.engine.setDisplayMode(DisplayMode.Normal);
    }
  }
}
