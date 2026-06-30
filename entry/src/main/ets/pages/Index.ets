import { RenderEngine } from '../render/RenderEngine';
import { InteractionManager } from '../interaction/InteractionManager';

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private engine: RenderEngine = new RenderEngine();
  private interaction: InteractionManager | null = null;
  @State canvasW: number = 466;
  @State canvasH: number = 466;

  aboutToAppear() {
    this.interaction = new InteractionManager(this.engine);
  }

  aboutToDisappear() {
    this.engine.destroy();
  }

  build() {
    Stack() {
      Canvas(this.ctx)
        .width('100%')
        .height('100%')
        .backgroundColor('#1a2a3a')
        .onAreaChange((_: Area, newArea: Area) => {
          const w = newArea.width as number;
          const h = newArea.height as number;
          if (w > 0 && h > 0) {
            this.canvasW = w;
            this.canvasH = h;
            this.engine.init(this.ctx, w, h);
            this.engine.start();
          }
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Up) {
            this.interaction?.onTap();
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
