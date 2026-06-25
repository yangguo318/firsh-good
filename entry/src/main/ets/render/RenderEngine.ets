import { DisplayMode, ClockStyle, KoiTheme, PetalDensity } from './Settings';
import { BackgroundLayer } from './layers/BackgroundLayer';
import { WaterSurfaceLayer } from './layers/WaterSurfaceLayer';
import { PetalLayer } from './layers/PetalLayer';
import { KoiLayer } from './layers/KoiLayer';
import { ClockLayer } from './layers/ClockLayer';
import { AODLayer } from './layers/AODLayer';

export { DisplayMode, ClockStyle, KoiTheme, PetalDensity };

export class RenderEngine {
  private ctx: CanvasRenderingContext2D | null = null;
  private W: number = 466;
  private H: number = 466;
  private timer: number = 0;
  private frameCount: number = 0;
  private displayMode: DisplayMode = DisplayMode.Normal;
  private clockStyle: ClockStyle = ClockStyle.Digital;
  private koiTheme: KoiTheme = KoiTheme.Mixed;
  private petalDensity: PetalDensity = PetalDensity.Normal;

  private bgLayer: BackgroundLayer = new BackgroundLayer();
  private waterLayer: WaterSurfaceLayer = new WaterSurfaceLayer();
  private petalLayer: PetalLayer = new PetalLayer();
  private koiLayer: KoiLayer = new KoiLayer();
  private clockLayer: ClockLayer = new ClockLayer();
  private aodLayer: AODLayer = new AODLayer();

  init(ctx: CanvasRenderingContext2D, w: number, h: number): void {
    this.ctx = ctx;
    this.W = w;
    this.H = h;
  }

  getW(): number {
    return this.W;
  }

  getH(): number {
    return this.H;
  }

  getFrameCount(): number {
    return this.frameCount;
  }

  getDisplayMode(): DisplayMode {
    return this.displayMode;
  }

  setDisplayMode(mode: DisplayMode): void {
    this.displayMode = mode;
  }

  getClockStyle(): ClockStyle {
    return this.clockStyle;
  }

  setClockStyle(style: ClockStyle): void {
    this.clockStyle = style;
    this.clockLayer.setStyle(style);
  }

  getKoiTheme(): KoiTheme {
    return this.koiTheme;
  }

  setKoiTheme(theme: KoiTheme): void {
    this.koiTheme = theme;
    this.koiLayer.setTheme(theme);
  }

  getPetalDensity(): PetalDensity {
    return this.petalDensity;
  }

  setPetalDensity(density: PetalDensity): void {
    this.petalDensity = density;
    this.petalLayer.setDensity(density);
  }

  start(): void {
    if (this.timer) {
      return;
    }
    this.timer = setInterval(() => {
      this.renderFrame();
    }, 50);
  }

  stop(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = 0;
    }
  }

  destroy(): void {
    this.stop();
    this.ctx = null;
  }

  private renderFrame(): void {
    const c = this.ctx;
    if (!c) {
      return;
    }
    const w = this.W;
    const h = this.H;
    c.clearRect(0, 0, w, h);

    if (this.displayMode === DisplayMode.AOD) {
      this.aodLayer.draw(c, w, h, this.frameCount);
      this.frameCount++;
      return;
    }

    this.bgLayer.draw(c, w, h);
    this.waterLayer.draw(c, w, h, this.frameCount);
    this.petalLayer.draw(c, w, h, this.frameCount);
    this.koiLayer.draw(c, w, h, this.frameCount);
    this.clockLayer.draw(c, w, h);

    this.frameCount++;
  }
}
