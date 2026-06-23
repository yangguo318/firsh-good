export default {
    data: {
        clockTimer: null,
        fishTimer: null,
        // 金鱼状态
        fishA: { x: 100, y: 280, dir: 1, angle: 0 },
        fishB: { x: 300, y: 200, dir: -1, angle: 0 },
        fishC: { x: 200, y: 320, dir: 1, angle: 0 },
    },

    onInit() {
    },

    onShow() {
        // 初始化背景
        this.drawBackground();

        // 启动时钟更新（1秒）
        this.clockTimer = setInterval(() => {
            this.drawClockHands();
        }, 1000);

        // 启动金鱼游动（50ms = 20fps）
        this.fishTimer = setInterval(() => {
            this.updateFishPositions();
            this.drawFish();
        }, 50);

        // 初始绘制时钟
        this.drawClockHands();
    },

    onHide() {
        if (this.clockTimer) {
            clearInterval(this.clockTimer);
            this.clockTimer = null;
        }
        if (this.fishTimer) {
            clearInterval(this.fishTimer);
            this.fishTimer = null;
        }
    },

    onDestroy() {
        if (this.clockTimer) {
            clearInterval(this.clockTimer);
        }
        if (this.fishTimer) {
            clearInterval(this.fishTimer);
        }
    },

    drawBackground() {
        const canvas = this.$element('bgCanvas');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');

        // 天空渐变（深蓝到墨绿）
        const skyGradient = ctx.createLinearGradient(0, 0, 0, 220);
        skyGradient.addColorStop(0, '#0d1b2a');
        skyGradient.addColorStop(0.7, '#1b3a4b');
        skyGradient.addColorStop(1, '#2d4a3a');
        ctx.fillStyle = skyGradient;
        ctx.fillRect(0, 0, 454, 220);

        // 水面（深青色渐变）
        const waterGradient = ctx.createLinearGradient(0, 220, 0, 454);
        waterGradient.addColorStop(0, '#1a3a4a');
        waterGradient.addColorStop(0.5, '#12303d');
        waterGradient.addColorStop(1, '#0a1a28');
        ctx.fillStyle = waterGradient;
        ctx.fillRect(0, 220, 454, 234);

        // 月亮（右上角）
        ctx.fillStyle = 'rgba(255, 250, 220, 0.15)';
        ctx.beginPath();
        ctx.arc(360, 60, 30, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillStyle = 'rgba(255, 250, 220, 0.08)';
        ctx.beginPath();
        ctx.arc(360, 60, 45, 0, Math.PI * 2);
        ctx.fill();

        // 远山（水墨风格，两层）
        ctx.fillStyle = 'rgba(40, 60, 80, 0.4)';
        ctx.beginPath();
        ctx.moveTo(0, 190);
        ctx.quadraticCurveTo(60, 160, 130, 175);
        ctx.quadraticCurveTo(180, 150, 240, 170);
        ctx.quadraticCurveTo(300, 145, 370, 168);
        ctx.quadraticCurveTo(420, 155, 454, 180);
        ctx.lineTo(454, 220);
        ctx.lineTo(0, 220);
        ctx.closePath();
        ctx.fill();

        // 近山
        ctx.fillStyle = 'rgba(30, 50, 60, 0.5)';
        ctx.beginPath();
        ctx.moveTo(0, 205);
        ctx.quadraticCurveTo(50, 185, 110, 198);
        ctx.quadraticCurveTo(160, 178, 220, 195);
        ctx.quadraticCurveTo(280, 180, 350, 195);
        ctx.quadraticCurveTo(410, 185, 454, 200);
        ctx.lineTo(454, 220);
        ctx.lineTo(0, 220);
        ctx.closePath();
        ctx.fill();

        // 曲桥（拱桥轮廓）
        ctx.strokeStyle = 'rgba(80, 100, 90, 0.5)';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(50, 215);
        ctx.quadraticCurveTo(120, 190, 190, 215);
        ctx.stroke();
        // 桥柱
        ctx.strokeStyle = 'rgba(80, 100, 90, 0.3)';
        ctx.lineWidth = 1;
        for (let i = 0; i < 5; i++) {
            const bx = 65 + i * 25;
            const by = 215 - Math.sin((bx - 50) / 140 * Math.PI) * 25;
            ctx.beginPath();
            ctx.moveTo(bx, by);
            ctx.lineTo(bx, 220);
            ctx.stroke();
        }

        // 柳树（左上角垂柳）
        ctx.strokeStyle = 'rgba(50, 80, 50, 0.5)';
        ctx.lineWidth = 2;
        // 树干
        ctx.beginPath();
        ctx.moveTo(20, 100);
        ctx.quadraticCurveTo(15, 140, 25, 190);
        ctx.stroke();
        // 柳枝
        ctx.strokeStyle = 'rgba(60, 100, 60, 0.4)';
        ctx.lineWidth = 1;
        for (let i = 0; i < 8; i++) {
            ctx.beginPath();
            const startY = 120 + i * 8;
            ctx.moveTo(20, startY);
            ctx.quadraticCurveTo(40 + i * 3, startY + 30, 30 + i * 5, startY + 55);
            ctx.stroke();
        }

        // 荷叶
        this.drawLotusLeaf(ctx, 100, 255, 30);
        this.drawLotusLeaf(ctx, 320, 270, 25);
        this.drawLotusLeaf(ctx, 200, 300, 35);
        this.drawLotusLeaf(ctx, 370, 320, 28);
        this.drawLotusLeaf(ctx, 150, 330, 22);
        this.drawLotusLeaf(ctx, 280, 340, 26);

        // 荷花
        this.drawLotusFlower(ctx, 130, 235, 14);
        this.drawLotusFlower(ctx, 340, 250, 11);
        this.drawLotusFlower(ctx, 230, 280, 12);

        // 水面波纹
        ctx.strokeStyle = 'rgba(120, 200, 220, 0.15)';
        ctx.lineWidth = 0.5;
        for (let i = 0; i < 6; i++) {
            const wx = 60 + i * 65;
            const wy = 360 + (i % 3) * 20;
            ctx.beginPath();
            ctx.arc(wx, wy, 15 + i * 3, 0, Math.PI * 2);
            ctx.stroke();
        }

        // 水面光斑
        ctx.fillStyle = 'rgba(180, 220, 240, 0.05)';
        for (let i = 0; i < 10; i++) {
            ctx.beginPath();
            ctx.arc(50 + i * 40, 280 + (i % 3) * 40, 3, 0, Math.PI * 2);
            ctx.fill();
        }
    },

    drawLotusLeaf(ctx, x, y, radius) {
        ctx.fillStyle = 'rgba(40, 100, 60, 0.7)';
        ctx.beginPath();
        ctx.arc(x, y, radius, 0, Math.PI * 2);
        ctx.fill();

        // 叶脉
        ctx.strokeStyle = 'rgba(30, 70, 40, 0.5)';
        ctx.lineWidth = 1;
        for (let i = 0; i < 6; i++) {
            const angle = (i * Math.PI) / 3;
            ctx.beginPath();
            ctx.moveTo(x, y);
            ctx.lineTo(x + Math.cos(angle) * radius, y + Math.sin(angle) * radius);
            ctx.stroke();
        }
    },

    drawEllipse(ctx, x, y, rx, ry) {
        ctx.save();
        ctx.translate(x, y);
        ctx.scale(rx / ry, 1);
        ctx.arc(0, 0, ry, 0, Math.PI * 2);
        ctx.restore();
    },

    drawRotatedEllipse(ctx, x, y, rx, ry, rotation) {
        ctx.save();
        ctx.translate(x, y);
        ctx.rotate(rotation);
        ctx.scale(rx / ry, 1);
        ctx.arc(0, 0, ry, 0, Math.PI * 2);
        ctx.restore();
    },

    drawLotusFlower(ctx, x, y, size) {
        ctx.fillStyle = 'rgba(255, 180, 200, 0.8)';
        for (let i = 0; i < 5; i++) {
            const angle = (i * Math.PI * 2) / 5;
            this.drawRotatedEllipse(
                ctx,
                x + Math.cos(angle) * size * 0.5,
                y + Math.sin(angle) * size * 0.5,
                size * 0.6,
                size * 0.3,
                angle
            );
            ctx.fill();
        }
        // 花蕊
        ctx.fillStyle = 'rgba(255, 220, 100, 0.9)';
        ctx.beginPath();
        ctx.arc(x, y, size * 0.3, 0, Math.PI * 2);
        ctx.fill();
    },

    updateFishPositions() {
        // 金鱼A：左右游动
        this.fishA.x += this.fishA.dir * 1.2;
        this.fishA.y += Math.sin(this.fishA.angle) * 0.5;
        this.fishA.angle += 0.05;
        if (this.fishA.x > 380 || this.fishA.x < 60) {
            this.fishA.dir *= -1;
        }

        // 金鱼B：反向游动
        this.fishB.x += this.fishB.dir * 0.9;
        this.fishB.y += Math.sin(this.fishB.angle) * 0.4;
        this.fishB.angle += 0.04;
        if (this.fishB.x > 360 || this.fishB.x < 80) {
            this.fishB.dir *= -1;
        }

        // 金鱼C：较慢游动
        this.fishC.x += this.fishC.dir * 0.7;
        this.fishC.y += Math.sin(this.fishC.angle) * 0.3;
        this.fishC.angle += 0.03;
        if (this.fishC.x > 340 || this.fishC.x < 100) {
            this.fishC.dir *= -1;
        }
    },

    drawFish() {
        const canvas = this.$element('fishCanvas');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, 454, 454);

        this.drawGoldfish(ctx, this.fishA.x, this.fishA.y, this.fishA.dir, '#ff6b35', this.fishA.angle * 3);
        this.drawGoldfish(ctx, this.fishB.x, this.fishB.y, this.fishB.dir, '#ffa500', this.fishB.angle * 3);
        this.drawGoldfish(ctx, this.fishC.x, this.fishC.y, this.fishC.dir, '#dc143c', this.fishC.angle * 3);
    },

    drawGoldfish(ctx, x, y, dir, color, tailPhase) {
        ctx.save();
        ctx.translate(x, y);
        ctx.scale(dir, 1);

        // 身体
        ctx.fillStyle = color;
        ctx.beginPath();
        this.drawEllipse(ctx, 0, 0, 18, 10);
        ctx.fill();

        // 尾巴（根据游动阶段摆动）
        const tailSwing = Math.sin(tailPhase) * 6;
        ctx.beginPath();
        ctx.moveTo(-15, 0);
        ctx.quadraticCurveTo(-22, tailSwing - 3, -28, tailSwing - 8);
        ctx.lineTo(-26, tailSwing);
        ctx.lineTo(-28, tailSwing + 8);
        ctx.quadraticCurveTo(-22, tailSwing + 3, -15, 0);
        ctx.closePath();
        ctx.fill();

        // 眼睛
        ctx.fillStyle = '#000';
        ctx.beginPath();
        ctx.arc(10, -3, 2, 0, Math.PI * 2);
        ctx.fill();
        // 眼睛高光
        ctx.fillStyle = 'rgba(255,255,255,0.6)';
        ctx.beginPath();
        ctx.arc(10.5, -3.5, 0.8, 0, Math.PI * 2);
        ctx.fill();

        // 鱼鳍
        ctx.fillStyle = color;
        ctx.globalAlpha = 0.5;
        ctx.beginPath();
        this.drawRotatedEllipse(ctx, -3, -8, 6, 3, -0.3);
        ctx.fill();
        ctx.globalAlpha = 1;

        // 鳞片高光
        ctx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
        ctx.lineWidth = 0.5;
        for (let i = 0; i < 3; i++) {
            ctx.beginPath();
            ctx.arc(-5 + i * 6, 0, 4, -0.5, 0.5);
            ctx.stroke();
        }

        ctx.restore();
    },

    drawClockHands() {
        const canvas = this.$element('clockCanvas');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, 454, 454);

        const now = new Date();
        const cx = 227;
        const cy = 227;

        // 绘制数字时间（顶部）
        const h = String(now.getHours()).padStart(2, '0');
        const m = String(now.getMinutes()).padStart(2, '0');
        const s = String(now.getSeconds()).padStart(2, '0');
        ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
        ctx.font = '36px sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(`${h}:${m}:${s}`, cx, 120);

        // 绘制日期（底部）
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
        const weekday = weekdays[now.getDay()];
        ctx.fillStyle = 'rgba(255, 255, 255, 0.6)';
        ctx.font = '16px sans-serif';
        ctx.fillText(`${year}年${month}月${day}日 ${weekday}`, cx, 395);

        // 计算角度（12点方向为0度，顺时针）
        const secAngle = (now.getSeconds() / 60) * 360 - 90;
        const minAngle = ((now.getMinutes() + now.getSeconds() / 60) / 60) * 360 - 90;
        const hrAngle = ((now.getHours() % 12 + now.getMinutes() / 60) / 12) * 360 - 90;

        // 绘制时针
        this.drawHand(ctx, cx, cy, hrAngle, 60, 5, 'rgba(255, 255, 255, 0.9)');
        // 绘制分针
        this.drawHand(ctx, cx, cy, minAngle, 85, 3, 'rgba(255, 255, 255, 0.85)');
        // 绘制秒针
        this.drawHand(ctx, cx, cy, secAngle, 95, 1.5, '#e85d4a');

        // 中心点
        ctx.fillStyle = '#e85d4a';
        ctx.beginPath();
        ctx.arc(cx, cy, 4, 0, Math.PI * 2);
        ctx.fill();

        // 刻度
        for (let i = 0; i < 12; i++) {
            const angle = (i * 30 - 90) * Math.PI / 180;
            const inner = i % 3 === 0 ? 100 : 105;
            const outer = 110;
            ctx.strokeStyle = i % 3 === 0 ? 'rgba(255, 255, 255, 0.8)' : 'rgba(255, 255, 255, 0.5)';
            ctx.lineWidth = i % 3 === 0 ? 2 : 1;
            ctx.beginPath();
            ctx.moveTo(cx + Math.cos(angle) * inner, cy + Math.sin(angle) * inner);
            ctx.lineTo(cx + Math.cos(angle) * outer, cy + Math.sin(angle) * outer);
            ctx.stroke();
        }
    },

    drawHand(ctx, cx, cy, angleDeg, length, width, color) {
        const angleRad = (angleDeg * Math.PI) / 180;
        const endX = cx + length * Math.cos(angleRad);
        const endY = cy + length * Math.sin(angleRad);

        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.lineTo(endX, endY);
        ctx.strokeStyle = color;
        ctx.lineWidth = width;
        ctx.lineCap = 'round';
        ctx.stroke();
    }
};
