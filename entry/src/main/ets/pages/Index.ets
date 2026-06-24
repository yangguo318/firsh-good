import { RenderEngine, ClockStyle } from '../render/RenderEngine';

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private engine: RenderEngine = new RenderEngine();
  private touchStartX: number = 0;
  private touchStartY: number = 0;

  aboutToAppear() {
    this.engine.init(this.ctx);
    this.engine.start();
  }

  aboutToDisappear() {
    this.engine.destroy();
  }

  build() {
    Stack() {
      Canvas(this.ctx)
        .width('100%')
        .height('100%')
        .backgroundColor('#0a1628')
        .onReady(() => {
          this.engine.init(this.ctx);
          this.engine.start();
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.touchStartX = event.touches[0].x;
            this.touchStartY = event.touches[0].y;
          } else if (event.type === TouchType.Up) {
            const dx = event.changedTouches[0].x - this.touchStartX;
            const dy = event.changedTouches[0].y - this.touchStartY;
            const dist = Math.sqrt(dx * dx + dy * dy);
            if (dist < 20) {
              this.handleTap();
            }
          }
        })
    }
    .width('100%')
    .height('100%')
  }

  private handleTap(): void {
    const current = this.engine.getClockStyle();
    if (current === ClockStyle.Digital) {
      this.engine.setClockStyle(ClockStyle.Minimal);
    } else if (current === ClockStyle.Minimal) {
      this.engine.setClockStyle(ClockStyle.Hidden);
    } else {
      this.engine.setClockStyle(ClockStyle.Digital);
    }
  }
}
