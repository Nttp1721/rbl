--[[═══════════════════════════════════════════════════════════════════════
    ███╗   ███╗███████╗██╗███████╗██╗   ██╗    ██╗██╗   ██╗██████╗
    ████╗ ████║██╔════╝██║██╔════╝██║   ██║    ██║██║   ██║██╔══██╗
    ██╔████╔██║█████╗  ██║███████╗██║   ██║    ██║██║   ██║██████╔╝
    ██║╚██╔╝██║██╔══╝  ██║╚════██║██║   ██║    ██║██║   ██║██╔══██╗
    ██║ ╚═╝ ██║███████╗██║███████║╚██████╔╝    ██║╚██████╔╝██████╔╝
    ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝ ╚═════╝     ╚═╝ ╚═════╝ ╚═════╝
    ═══════════════════════════════════════════════════════════════════════
    MEIZU HUB — BLOX FRUITS · HALLOWEEN EVENT 2026 · v5.2 FIXED
    ────────────────────────────────────────────────────────────────────────
    • Nền tảng UI : Meizu Library (Nttp1721) — bản v3.1 "Luxe"
    • Tham khảo   : Banana Cat Hub (meizublf.lua) — tween / fast attack /
                    noclip / anti-AFK được viết lại gọn cho event
    • Tính năng   :
        [1] Auto Farm Bí Ngô (Jack O' Lantern Hunt) — 2 chế độ:
              + Tới gần từng bí ngô (tween + fast attack remote)
              + Đập trong tầm (hết tầm → tự bay đuổi, không đứng im)
        [2] ESP Bí Ngô + PumpkinPatch (Highlight + BillTag khoảng cách)
        [3] Auto Gõ Cửa (Trick-or-Treat mỗi giờ XX:00)
        [4] Auto Roll Gacha / Tương tác Phù Thủy (ProximityPrompt)
        [5] Nhặt đồ rơi (Candy Corn / Pumpkin Bits)
        [6] Anti-AFK · Hop Server · Rejoin · Watermark FPS/Ping
    ────────────────────────────────────────────────────────────────────────
    CÁCH DÙNG — upload file này lên repo Nttp1721/rbl (nhánh main) với tên:
        MeizuHub-Halloween2026.lua
    rồi chạy bằng:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/MeizuHub-Halloween2026.lua"))()

    ═══ UPDATE v2.1 — FIX THEO FEEDBACK ═══
    • FIX "bật farm xong tự tắt khi tele tới bí ngô": bản cũ click chuột ảo
      NGAY GIỮA MÀN HÌNH → cú click rơi trúng cửa sổ Hub đang mở → tự bấm
      trúng toggle Farm → farm tắt. Giờ script tự tìm điểm màn hình KHÔNG
      có UI để click + tự thu nhỏ Hub khi farm (Ctrl trái mở lại).
    • Đánh M1 GIẢ LẬP NGƯỜI THẬT: nhấn-giữ chuột 40-90ms, nhịp 0.30-0.42s
      ngẫu nhiên, quay người + camera vào bí ngô → server mới cộng damage.
    • FIX "bay chui xuống nước": tween dò mặt đất/mặt nước bằng raycast,
      luôn giữ 3-3.5 studs phía trên → không chìm dưới biển nữa.
    • GIẢM LAG: 1 cache quét map duy nhất (tối đa 1 lần/1.2s) thay vì
      5-10 lần GetDescendants mỗi giây; noclip dùng list cache;
      ESP giới hạn 100 vật thể.

    ═══ UPDATE v2.2 — FARM LIÊN TỤC + ĐÁNH SÁT + AUTO BUSO ═══
    • Đánh bí ngô GẦN trước → hết gần thì TỰ BAY ra vùng XA đập tiếp,
      không bao giờ đứng im chờ (farm liên tục).
    • Bay đứng SÁT CẠNH bí ngô (3.5–5 studs, chỉnh bằng slider) — bản cũ
      đứng 10+ studs nên M1 trượt ("đánh không dính"). Bị văng ra xa thì
      TỰ BAY LẠI sát bí ngô, không bỏ quả giữa chừng.
    • AUTO BẬT BUSO HAKI (Aura): CommF_:InvokeServer("Buso") — kỹ thuật
      lấy từ Banana Cat Hub → đập bí ngô đau hơn hẳn.

    ═══ UPDATE v2.4 — KHÓA MỤC TIÊU + GIỚI HẠN VÙNG FARM ═══
    • Chỉ farm bí ngô có marker sự kiện hoặc nằm trong PumpkinPatch;
      không fallback sang bí ngô trang trí khi không tìm được patch.
    • Giới hạn vùng tìm quanh vị trí bật farm, tránh bay dây chuyền qua map.
    • Quả đập hoài không mất máu → cấm 120s (trước 15s) → không bay
      đi bếp lại quả giả nữa.
    • Nhặt đồ KHÔNG dịch chuyển nhân vật khi farm đang bật (hết bị kéo
      sang nhặt "Candy Corn" trang trí ở khu Gacha).
    • Auto Gõ Cửa / Gacha: khi farm bật chỉ bấm prompt TRONG TẦM đánh,
      KHÔNG tween đi nơi khác + cooldown 6s/prompt → hết spam lỗi
      "[DIALOGUE] there's already an active dialogue".

    ═══ UPDATE v2.5 — ANTI-BAN + FIX FARM ĐI + GÕ CỬA LOCKED ═══
    • ANTI-BAN / ANTI-CHEAT (mượn + cải thiện từ Banana Cat Hub):
      ElevateIdentity, tắt StreamingEnabled, SimulationRadius 5000 mỗi
      Heartbeat, Anti-Kick (hook __namecall chặn LocalPlayer:Kick()).
      → Owner có thể test anticheat.
    • GIỚI HẠN tốc độ bay MAX 250 studs/s (slider + clamp trong tween)
      — vượt sẽ bị anticheat server kéo về gây "tele chỗ không có bí ngô".
    • FIX "bật auto farm pumpkin không đi": v2.4 yêu cầu bí ngô phải nằm
      trong PumpkinPatch → nếu game không có patch nào (hoặc patch rỗng)
      thì KHÔNG chọn được mục tiêu → farm đứng im. Giờ FALLBACK: không có
      patch → chấp nhận mọi bí ngô tên "Pumpkin" (như v2.2 vẫn chạy ngon).
    • FIX "tự tele chỗ không có bí ngô": sau khi tween tới, KIỂM TRA mục
      tiêu vẫn còn & đang GẦN → mới đập. Mục tiêu biến mất / bị kéo xa
      → blacklist + chọn quả khác NGAY (không đứng đập khoảng trống).
    • FIX "auto trick-or-treat không gõ cửa": gõ CẢ ProximityPrompt LẪN
      ClickDetector + broaden keyword (door,house,knock,trick,treat...).
    • LOCKED DOOR → ĐỔI NHÀ: gõ xong đợi 3s đọc Candy — TĂNG = thành
      công; KHÔNG tăng (và detect candy reliable) = LOCKED → khóa 180s
      + tự sang nhà khác. Mỗi cửa cooldown 30s (không gõ lại cùng cửa).
    • THÔNG BÁO: mọi toggle đều notify BẬT/TẮT + trạng thái gõ cửa.

    ═══ UPDATE v2.6 — FIX TỐC ĐỘ + ĐỨNG NGANG TẦM + LỌC CONSOLE ═══
    • FIX "bay nhanh quá 250": Y bump (chống chìm nước) từng làm tổng vận tốc
      3D > 250 studs/s khi bay qua đồi. Giờ scale XZ lại → tổng 3D KHÔNG bao
      giờ vượt 250. BodyVelocity mạnh hơn (MaxForce 1e6) dập hết physics.
    • FIX "đứng cao hơn không đánh tới bí ngô": safeStandPos bỏ +3.5, đứng
      NGANG TẦM bí ngô (chỉ nâng nếu dưới mặt đất/nước). M1 + camera nhìn
      thẳng → đánh DÍNH 100%.

    ═══ UPDATE v2.7 — FIX VĂNG GAME (CRITICAL) ═══
    • FIX "chạy script xong bị văng game": v2.6 hook `warn` bằng hookfunction
      → hookfunction thay hàm IN-PLACE → `oldWarn = warn` lưu tham chiếu bị
      thay → oldWarn(...) gọi lại hook → ĐỆ QUY VÔ HẠN → STACK OVERFLOW →
      CRASH. Đã XÓA hoàn toàn hook warn (console hiện lỗi game là bình thường,
      không ảnh hưởng farm).
    • StreamingMinRadius/TargetRadius: giảm từ 1e8 → 5000 (1e8 quá lớn →
      client cố load cả map → tràn RAM → crash).
    • Anti-Kick: MẶC ĐỊNH TẮT (hook __namecall có thể bị anticheat phát
      hiện → chỉ bật khi owner test thấy bị kick).
    • Tốc độ bay 230 + đứng ngang bí ngô (giữ từ v2.6).

    ═══ UPDATE v2.9 — FIX ĐỨNG TRÊN NÓC + STAND=1 + NOCLIP MẠNH ═══
    • FIX "đứng trên nóc nhà / ngọn cây": safeStandPos + tween ground-safe
      CHỈ bump Y cho MẶT NƯỚC (chống chìm). Đất / nóc nhà / ngọn cây →
      KHÔNG bump → nhân vật bay XUYÊN (noclip) vào trong nhà / dưới cây,
      đứng NGANG TẦM bí ngô (không trên nóc nữa).
    • StandDist = 1 (CỐ ĐỊNH, không cho chỉnh): luôn đứng kế bên bí ngô.
      Đã xóa slider "Khoảng cách đứng khi đập".
    • NOCLIP viết lại: bỏ cache 1s (bản cũ → part mới không được disable →
      kẹt tường). Bản mới quét GetDescendants MỖI FRAME → CanCollide=false
      trên TẤT CẢ BasePart → chắc chắn xuyên tường/nóc/cây.
    • Tween stopDist giảm 3.5→2: đến sát hơn, đập DÍNH hơn.
    • Tốc độ bay 230 studs/s (theo yêu cầu owner trước đó).

    ═══ UPDATE v3.0 — FAST ATTACK CHO QUÁI JACK O' LANTERN ═══
    • TỰ ĐỘNG chọn cách đánh theo loại mục tiêu:
        + Pumpkin (bí ngô sự kiện) → M1 giả lập người thật (ổn định, server
          không chặn). Remote toggle giờ CHỈ cho pumpkin (mặc định TẮT).
        + Quái Jack o' Lantern (workspace.Enemies) → FAST ATTACK kiểu Banana
          Cat Hub: AttackAOE pattern — lọc body part (Head/Torso/Arms/Legs),
          GetRigOfHitPart, IsVulnerable, RegisterAttack+RegisterHit (no-anim).
          → Đánh NHANH + DÍNH, không cần bật toggle.
    • isEventPumpkinTarget: chấp nhận quái workspace.Enemies làm mục tiêu farm
      (không cần nằm trong PumpkinPatch).
    • Toggle "Remote" đổi tên → "Remote cho Pumpkin" (Jack o' Lantern luôn
      fast attack, không cần toggle).

    ═══ UPDATE v3.1 — COPY NGUYÊN CƠ CHẾ FARM BCH + STAND=3 ═══
    • FIX "fast attack không hoạt động": bản v3.0 chỉ quét 1 model → sai.
      Giờ copy NGUYÊN cơ chế farm Banana Cat Hub (Attack No Animation):
        + getBladeHits: quét TẤT CẢ quái trong workspace.Enemies (trong range),
          thu thập BasePart của mỗi con → AOE đánh NHIỀU quái 1 phát.
        + AttackAOE: lọc BODY_PARTS + GetRigOfHitPart + IsVulnerable.
        + RegisterAttack:FireServer(0) + RegisterHit:FireServer(firstPart, hitList).
    • Hit delay quái: 0.05-0.08s (BCH fast attack, cực nhanh) — pumpkin vẫn
      M1 nhịp người thật 0.30-0.42s.
    • StandDist = 3 (đổi từ 1 → 3 theo yêu cầu owner).

    ═══ UPDATE v3.2 — FIX LỖI FULL SCRIPT (REMOTE SETUP) ═══
    • FIX "fast attack làm lỗi full script": bản v3.1 gọi Net:RemoteEvent()
      trên ModuleScript INSTANCE → lỗi (ModuleScript không có method :RemoteEvent).
      Giờ require() ra TABLE trước (giống BCH: local m = require(Net)) rồi mới
      gọi m:RemoteEvent("RegisterHit", true) → đúng pattern BCH.
    • Bỏ table.clear (Lua 5.1 thuần không có) → cleanup thủ công.
    • Bỏ getPartsInRange thừa → gộp vào getBladeHits (giống BCH function m).
    • Shadow variable fix: local radius = radius or 80 → đổi tên thành `rad`.
    • TOÀN BỘ fast attack pcall → lỗi bất kỳ chỉ return false → fallback M1,
      KHÔNG bao giờ crash script.

    ═══ UPDATE v3.3 — FIX TRICK-OR-TREAT + TELE MODE + STAND WATER FIX ═══
    • FIX "gõ cửa không tương tác event": doorLoop giờ dùng
      MaxActivationDistance của prompt để bay ĐỦ GẦN rồi fire 2 lần (pcall).
      fireDoor thử fireproximityprompt + fallback InputHoldBegin/End (E hold).
    • AUTO ATTACK MOBS: khi gõ cửa spawn quái nhỏ → tự fast attack AOE 6s
      (đánh TẤT CẢ quái trong range). Toggle "Tự đánh quái spawn" (mặc định BẬT).
    • TELE MODE (BCH style): toggle "Tele mode" — BẬT = set CFrame tức thì
      (không tween, nhanh, không kẹt terrain). TẮT = tween (mặc định).
    • FIX "rớt nước khi đứng kế pumpkin": safeStandPos giờ nâng Y khi pumpkin
      ở DƯỚI mặt đất/nước (không chỉ nước) → không rơi nước/chìm nữa.

    ═══ UPDATE v3.4 — FIX TÊ LIỆT SCRIPT (CRITICAL) ═══
    • FIX "script tê liệt không làm gì được": bản v3.3 autoAttackMobsNearby
      spawn thread spam fast attack mỗi 0.05s × 6s = 120 lần fire remote →
      server rate-limit/kick → script tê liệt. + task.wait(6) block doorLoop
      → không tắt toggle được.
    • Giờ autoAttackMobsNearby KHÔNG spawn thread, chỉ fire 1 lần. doorLoop
      vòng lặp nhỏ 4s, yield 0.4s/lần → phản hồi ngay khi tắt toggle.
    • fireDoor giảm từ 2 lần → 1 lần (không spam server).

    ═══ UPDATE v3.5 — FIX LẠI "TELE LÊN NÓC NHÀ / GÓC CÂY" ═══
    • FIX regression v3.3: safeStandPos bump Y khi baseY < gY (gY = raycast
      hit) → pumpkin TRONG nhà (dưới mái nhà) → gY = MÁI NHÀ → bump lên nóc!
      pumpkin DƯỚI cây → gY = ngọn cây → bump lên ngọn cây!
    • Giờ safeStandPos CHỈ bump Y khi raycast hit = MẶT NƯỚC (chống chìm).
      Đất / mái nhà / ngọn cây → KHÔNG bump → noclip xuyên, đứng ngang tầm.
    • Bump nước chia 2 mức: sâu >5 studs → +2, nông → +0.5 (chống chìm nhẹ).

    ═══ UPDATE v3.6 — ANTI-WATER SAFETY NET (TE MODE KHÔNG CHÌM NƯỚC) ═══
    • FIX "tele xuống dưới nước": MZ_Teleport giờ check mặt nước tại điểm tele
      → nếu dưới nước, bump Y lên mặt nước + 2 studs TRƯỚC khi set CFrame.
    • ANTI-WATER HEARTBEAT: mỗi 0.2s (khi farm/trick BẬT), nếu nhân vật dưới
      mặt nước → bump Y lên trên. Chống chìm nước trong MỌI trường hợp:
      tele, tween, game physics rớt xuống, bị quái đẩy xuống...
    • Chỉ bump khi isWater=true → đất/roof/cây KHÔNG bump (noclip vẫn xuyên).
    • Chỉ chạy khi Farm/Trick BẬT → không annoy người chơi bơi tự do.

    ═══ UPDATE v3.7 — CHỐNG CHẠM NƯỚC (DEVIL FRUIT USER) ═══
    • FIX "ăn Devil Fruit xuống nước mất máu chết": Devil Fruit user chạm
      nước = mất máu liên tục → chết. Phải KHÔNG cho chạm nước LUÔN (không
      phải bump lên sau khi chạm → PREVENT chặn trước).
    • NoWater Heartbeat: mỗi frame, raycast xuống 10 studs → nếu thấy mặt
      nước gần (<4 studs dưới chân) → KHOÁ Y giữ trên mặt nước +4 studs +
      reset velocity Y = 0 → KHÔNG BAO GIỜ chạm nước.
    • MZ_Teleport + safeStandPos + tween: tất cả bump Y +4 trên mặt nước
      (trước +2 studs, giờ +4 cho an toàn tuyệt đối).
    • Toggle "Chống chạm nước (NoWater)" ở tab Farm (mặc định BẬT).
    • Chỉ chạy khi Farm/Trick BẬT → người chơi bơi tự do (farm tắt) OK.

    ═══ UPDATE v3.8 — FLOAT HOÀI (GIỐNG BCH AUTO FARM) ═══
    • YÊU CẦU: "cho nó bay hoài luôn, không bao giờ rớt, đứng yên trên không
      kiểu BCH auto farm tween". → Đã thêm FLOAT KEEP-ALIVE.
    • Heartbeat mỗi 0.5s: khi Farm/Trick BẬT → giữ FloatForce (BodyVelocity
      Velocity=0, MaxForce=1e6) LUÔN → nhân vật ĐỨNG YÊN TRÊN KHÔNG mãi,
      gravity bị dập hoàn toàn → KHÔNG BAO GIỜ rơi.
    • Khi Farm/Trick TẮT → dọn FloatForce → rơi/bơi bình thường.
    • Tween mode: float giữa các cú tween (đứng yên trên không).
    • Tele mode: không cần float (set CFrame trực tiếp).

    ═══ UPDATE v3.9 — FIX RỚT NƯỚC TRIỆT ĐỂ (FLOAT LUÔN BẬT) ═══
    • FIX "rớt toàn dưới nước": bản v3.8 tween TẮT FloatForce ở cuối →
      khoảng trống 0.5s (heartbeat mới re-apply) → nhân vật rơi xuống nước!
    • Giờ: FloatForce BẬT LUÔN khi farm on, KHÔNG bao giờ tắt (kể cả khi
      tween đang chạy). Float (Velocity=0) KHÔNG cản trở tween (BodyVelocity
      chỉ dập velocity, KHÔNG chống set CFrame) → tween vẫn chạy bình thường.
    • Heartbeat MỖI FRAME re-apply float nếu bị xóa → không khoảng trống.
    • Xóa setFloatForce khỏi tween (đầu + cuối) → heartbeat quản lý toàn bộ.

    ═══ UPDATE v4.0 — REWRITE SẠCH (KHÔNG CHAP VÁ) ═══
    • User feedback: "bạn toàn chắp vá, gắn cái này vào cái khác". → Đã
      rewrite sạch, giống BCH: chỉ FloatForce + bump nước trực tiếp.
    • XÓA NoWater heartbeat (redundant — gây xung đột, bump +4 quá cao).
    • XÓA toggle NoWater (tự động, không cần).
    • groundwaterY() — hàm MỚI: chỉ trả về Y mặt NƯỚC (bỏ qua đất/roof/cây).
      groundYAt() wrapper lại → KHÔNG bao giờ trả về đất/roof Y.
    • safeStandPos/tween/MZ_Teleport: bump nước ĐƠN GIẢN — nếu điểm đến
      DƯỚI mặt nước → bump lên waterY + 2 studs. KHÔNG scale XZ phức tạp.
    • → KHÔNG chạm nước (Devil Fruit an toàn) + KHÔNG lên nóc nhà/cây
      (chỉ bump NƯỚC, KHÔNG bump đất/roof).

    ═══ UPDATE v4.1 — BAY CAO TRÊN ĐẦU QUÁI (BCH FARM STYLE) ═══
    • YÊU CẦU: "bay cao cao lên kiểu BCH auto farm, thấy bay cao trên đầu
      con quái để đánh; còn pumpkin thì đứng gần hợp lí rồi".
    • DISPATCH theo loại mục tiêu:
        + QUÁI Jack o' Lantern → bay CAO trên đầu (Y + 25 studs, lệch XZ 15)
          giống BCH farm style → đánh từ trên cao xuống.
        + PUMPKIN → đứng kế ben (3 studs, ngang tầm) — giữ nguyên.
    • State.EnemyStandDist = 15 (XZ), State.EnemyStandY = 25 (độ cao).
    • safeStandPosEnemy(): tính điểm đứng trên đầu quái.
    • farmLoop dispatch: isWorkspaceEnemy → enemy pos; else → pumpkin pos.

    ═══ UPDATE v4.2 — ANTI-BAN REWRITE (COPY + CẢI THIỆN BCH) ═══
    • 8 LỚP bảo vệ né anticheat, không bị ban acc:
      1. ElevateIdentity(8) — hết lỗi "lacking capability".
      2. StreamingFix — load cả map (BCH).
      3. SimulationRadius 5000 mỗi Heartbeat (BCH).
      4. Anti-Kick (hookmetamethod — KHÔNG setreadonly, an toàn hơn BCH).
      5. Anti-Teleport-Detect — tween ≤ 230 + FloatForce dập velocity.
      6. WalkSpeed/JumpPower clamp — KHÔNG set cao (chống ban).
      7. Anti-AFK — chống kick idle.
      8. Random jitter hit delay 0.05-0.08s — không đều như bot.
    • v5.2: bỏ queue_on_teleport quay lại JobId cũ vì có thể tạo vòng lặp Hop/Rejoin.
    • CẢI THIỆN so BCH: dùng hookmetamethod thay getrawmetatable+setreadonly
      → game không detect readonly flag change.

    ═══ UPDATE v5.0 — FULL EVENT REWRITE (THEO MENU + FEEDBACK) ═══
    • FIX "bấm E xong KHÔNG bấm tiếp tục": clickThroughDialogue() — kỹ thuật
      BCH (VirtualUser:Button1Down x2 khi PlayerGui.Main.Dialogue.Visible)
      + quét TextButton Continue/Ok/Next fire qua getconnections.
    • REWRITE Trick-or-Treat: E prompt → CLICK THOẠI → ĐÁNH QUÁI SPAWN
      (bay trên đầu BCH style + fast attack, chống chạm nước) → locked →
      đổi cửa khác. Vòng 40s, thoát sớm khi hết quái + hết thoại.
    • REWRITE Gacha: BCH remote RF/GachaNetworkRF (thử nhiều BoxName) +
      tự đóng SpinnerWindow (CloseButton fire) + prompt fallback.
    • NEW Boss: Auto Hellfire Gas / Auto Werewolf / Auto Summon (Dapper Jack
      tại cauldron) — bay trên đầu + fast attack AOE.
    • NEW Great Pumpkin section: Auto Great Pumpkin (Bits + Seeds), Ignore
      Jack o' Lantern, Ignore Pumpkin Snowman, Break Rare Pumpkin Only.
    • farmLoop: ENEMY PRIORITY — quái spawn khi đập bí ngô được ưu tiên
      (d*0.25) → bay trên đầu đánh trước rồi về đập tiếp.

    ═══ UPDATE v5.1 — FIX TOÀN BỘ THEO PHÂN TÍCH LỖI (STATE MACHINE) ═══
    • TRICK-OR-TREAT: DIALOG ENGINE hoàn chỉnh — snapshot nút trước khi gõ,
      tìm nút "Tiếp tục/Continue/Next/OK" (TextButton + ImageButton, text
      lồng trong TextLabel con), bấm bằng 4 LỚP: getconnections(Activated/
      MouseButton1Click):Fire() → firesignal → VIM click THẬT tại tâm nút →
      VirtualUser (BCH Main.Dialogue pattern). → HẾT lỗi "bấm E xong đứng
      ở Continue".
    • LOCKED THEO CĂN NHÀ (không theo từng prompt): houseState[Model nhà] —
      1 nhà nhiều prompt chỉ thử 1 lần. Phát hiện locked bằng 3 LỚP:
      (a) attribute Locked/IsLocked/Unlocked trên prompt → cửa → nhà,
      (b) TEXT thoại chứa "locked/khóa/not home/trở lại sau...",
      (c) Candy không tăng (leaderstats/Data/PlayerData/Stats).
    • CHỈ ĐÁNH QUÁI SPAWN TỪ CỬA: snapshot Enemies trước khi gõ → chỉ đánh
      quái MỚI xuất hiện gần cửa 90 studs (hết đánh lan sang quái khác).
    • M1 FALLBACK cho mọi nhánh combat: remote bị chặn/rate-limit 3 lần
      liên tiếp → tự chuyển M1 giả lập người thật (cửa + boss + farm).
    • BOSS STATE MACHINE: BOSS_DEFS (Hellfire Gas / Werewolf / Pumpkin
      Snowman / Great Pumpkin-Dapper Jack) — bay trên đầu + fast attack,
      phát hiện CHẾT → notify + chờ respawn, Auto Summon cooldown 12s,
      M1 fallback.
    • GACHA ĐẦY ĐỦ CHU TRÌNH: check Candy >= giá (slider, mặc định 500) →
      roll (remote RF/GachaNetworkRF + prompt fallback) → bấm thoại xác
      nhận → chờ spinner + tự đóng SpinnerWindow → đọc kết quả → notify.
      Server báo hết lượt (2 lượt/giờ) → TỰ TẮT. Slider delay + max rolls.
    • MOVE BUS: farm / trick-or-treat / boss / gacha / mystery hall KHÔNG
      còn giành nhau kéo nhân vật — chỉ 1 loop điều khiển di chuyển tại 1
      thời điểm, xen kẽ công bằng theo từng đơn vị công việc.
    • MYSTERY HALL (mới): tele vào hall + tự bấm prompt bên trong.
    • UNLOAD SẠCH: xóa FloatForce còn sót (hết "đứng freeze trên không") +
      KHÔI PHỤC collision khi tắt noclip / unload.
    • EVENT CHECK: bật TnT khi chưa thấy dấu hiệu event (cửa chỉ mở đầu
      giờ XX:00) → cảnh báo. Nút CHẨN ĐOÁN in prompt cửa + GUI ra console.
    • DỌN DEAD CODE: xóa promptLoop/promptLastFired/setFloatForce/
      groundYAt/NoWater/AntiTeleport (khai báo mà không dùng) — chống chạm
      nước + chống tele-detect đã TÍCH HỢP sẵn từ trước.

    ═══ UPDATE v5.2 — STABILITY + EVENT FLOW AUDIT ═══
    • Noclip chỉ chạy khi automation hoạt động; lưu và khôi phục CanCollide gốc.
    • MoveBus khóa theo coroutine; tween/tele chỉ chạy khi đúng tính năng sở hữu lease.
    • Lọc Fast Attack theo model mục tiêu; farm trong tầm dùng chung action lease.
    • Pickup nhận tên Model/Tool cha (Handle generic), tránh bỏ sót Pumpkin Bits.
    • Great Pumpkin kiểm tra 200 Bits + 3 Seeds; không thử Remote/BoxName phỏng đoán.
    • Gacha xác minh Candy giảm; Harvest Moon có gate theo 10 phút đầu giờ.
    • Dialogue dừng ở choice/minigame; đọc nested text; Unload dừng status loop và khôi phục trạng thái.
    • Harvest Moon gate được khai báo đúng scope; Inventory nhận diện alias Seed/Seeds.
    • Monster Chase là watcher; không giả vờ tự giải minigame khi chưa có layout runtime.
════════════════════════════════════════════════════════════════════════]]

-- ════════════════════════════ 0. CẤU HÌNH URL ════════════════════════════
local MEIZU_LIBRARY_URL =
        "https://raw.githubusercontent.com/Nttp1721/rbl/refs/heads/main/MeizuLibrary.lua"

-- ════════════════════════════ 1. ANTI-CHỒNG BẢN ═══════════════════════════
if getgenv().MZ_Halloween_Unload then
        pcall(getgenv().MZ_Halloween_Unload)
        task.wait(0.2)
end

-- ════════════════════════════ 2. SERVICES ═════════════════════════════════
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local VirtualUser     = game:GetService("VirtualUser")
local VIM             = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════ 3. TRẠNG THÁI CHUNG ═════════════════════════
local State = {
        -- Farm bí ngô
        FarmPumpkin   = false,
        FarmMode      = "Tới gần từng bí ngô",
        FarmTeleMode  = false, -- true = TELE (set CFrame tức thì, BCH style), false = tween
        FilterMode    = "Tất cả bí ngô",
        TweenSpeed    = 230, -- giới hạn MAX 230 studs/s (yêu cầu owner)
        HitRange      = 30,
        MaxFarmDistance = 350, -- bán kính tính từ vị trí bật farm; không cho đuổi mục tiêu xuyên map
        StandDist     = 3,    -- PUMPKIN: đứng kế ben bí ngô (3 studs) — không chỉnh được
        EnemyStandDist = 15,  -- QUÁI: khoảng cách XZ (bay cao trên đầu)
        EnemyStandY   = 25,   -- QUÁI: độ cao Y trên đầu quái (BCH farm style)
        AutoBuso      = true, -- tự bật Buso Haki (Aura) khi đánh
        AutoAttackMobs = true, -- auto đánh quái spawn khi gõ cửa (trick-or-treat)
        HitDelay      = 0.12,
        FastAttack    = false, -- remote thường bị server chặn → mặc định M1 người thật
        Noclip        = true, -- chỉ hoạt động khi automation đang di chuyển, không bật ngay khi nạp
        FarmOnlyPumpkins = false, -- Great Pumpkin mode: farm pumpkin thường, boss do Boss Controller xử lý
        PickupDrops   = true,
        PickupRadius  = 60,
        PickupKeywords = "candy,corn,pumpkin,bit,spooky,treat",
        StatusText    = "Tắt",

        -- ESP
        ESP          = false,
        ESPPatch     = false,
        ESPDistance  = true,
        ESPMaxRange  = 0, -- 0 = vô hạn
        ESPFill      = Color3.fromRGB(255, 100, 0),
        ESPOutline   = Color3.fromRGB(255, 200, 0),

        -- Sự kiện
        TrickOrTreat  = false,
        KnockKeywords = "knock,door,trick,treat,house,neighbor",
        KnockRadius   = 15000,
        Gacha         = false,
        GachaKeywords = "roll,gacha,zioles,spooky,halloween",

        -- Event v5.0 (menu đầy đủ như script khác)
        AutoHellfire     = false, -- auto đánh boss Hellfire Gas
        AutoWerewolf     = false, -- auto đánh boss Werewolf
        AutoGreatPumpkin = false, -- auto farm Great Pumpkin (Pumpkin Bits + Cursed Seeds)
        AutoSummon       = false, -- auto summon Dapper Jack tại cauldron
        IgnoreJackOLantern  = false, -- bỏ qua quái Jack o' Lantern
        IgnorePumpkinSnowman = false, -- bỏ qua Pumpkin Snowman
        BreakRareOnly    = false, -- chỉ đập bí ngô hiếm (Rare Pumpkin)
        EnemyPriority    = true, -- quái spawn khi đập bí ngô → ưu tiên đánh trước (bay trên đầu)

        -- Khác
        AntiAFK     = true,
        NoFX        = false,
        HideUIFarm  = true, -- thu nhỏ Hub khi farm (chống click ảo bấm nhầm nút)
        -- (Chống chạm nước KHÔNG cần toggle — đã xử lý TRỰC TIẾP trong
        --  safeStandPos / MZ_Tween / MZ_Teleport: bump lên mặt nước +2 studs.
        --  Anti-teleport cũng KHÔNG cần flag — tween ≤230 + FloatForce dập
        --  velocity là đủ, không set CFrame tức thì khi farm. [dọn dead-code v5.1])

        -- Anti-Ban / Anti-Cheat (mượn + cải thiện từ Banana Cat Hub)
        AntiBan     = false, -- thử nghiệm; không phải chống ban và mặc định không thay đổi streaming/identity
        AntiKick    = false, -- MẶC ĐỊNH TẮT — hook __namecall có thể bị anticheat phát hiện,
                             -- chỉ bật khi owner test và thấy bị kick (nếu game có kick client)

        -- v5.1 (fix theo phân tích lỗi)
        MysteryHall        = false, -- Mystery Hall: tele vào + tự tương tác prompt bên trong
        AutoSnowman        = false, -- auto đánh Pumpkin Snowman
        LockedDoorTime     = 180,   -- giây khóa 1 CĂN NHÀ khi phát hiện locked
        HouseVisitCooldown = 300,   -- giây nghỉ 1 nhà sau khi gõ thành công
        GachaPrice         = 500,   -- giá 1 lượt roll (Candy) — check đủ tiền trước khi roll
        GachaDelay         = 3,     -- giây nghỉ giữa 2 lượt roll
        GachaMaxRolls      = 0,     -- 0 = không giới hạn số lượt
}

local Connections = {}
local Unloaded = false
local OriginalCollision = setmetatable({}, { __mode = "k" })
local MoveBus = { owner = nil, thread = nil, since = 0 } -- lease gắn với coroutine để tránh thread khác nhả nhầm

-- KHAI BÁO SỚM để mọi hàm bên dưới (notify...) dùng chung 1 biến local
local Library -- sẽ gán ở mục 16 (Nạp thư viện Meizu)

-- (các loop chống chạy trùng bằng "generation counter" — xem farmLoop / busoLoop)

-- ════════════════════════════ 4. TIỆN ÍCH NHÂN VẬT ════════════════════════
local function getChar()
        return LocalPlayer.Character
end

local function getRoot()
        local c = LocalPlayer.Character
        return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
end

local function getHum()
        local c = LocalPlayer.Character
        return c and c:FindFirstChildOfClass("Humanoid")
end

local function notify(title, content, typ)
        pcall(function()
                Library:Notify({ Title = title, Content = content, Duration = 5, Type = typ or "info" })
        end)
end

-- ════════════════════════════ 4b. ANTI-BAN / ANTI-CHEAT (REWRITE v4.2) ═════
-- Copy + CẢI THIỆN từ Banana Cat Hub (meizublf.lua). Mục tiêu: né anticheat,
-- không bị ban acc khi farm lâu / bay xa / teleport.
--
-- CÁC LỚP BẢO VỆ:
--   1. ElevateIdentity(8)       — nâng thread identity → hết lỗi "lacking capability".
--   2. StreamingFix             — mở rộng StreamingRadius → load cả map (BCH).
--   3. SimulationRadius 5000    — mỗi Heartbeat (BCH) → vật thể xa không unload.
--   4. Anti-Kick (__namecall)   — chặn LocalPlayer:Kick() + remote kick.
--      ⚠ CẢI THIỆN: bản cũ getrawmetatable + setreadonly(false) → nguy hiểm (game
--        có thể detect). Dùng hookmetamethod (an toàn hơn, không đổi readonly).
--   5. Anti-Teleport-Detect     — KHÔNG set CFrame quá nhanh (tween ≤ 230 + float).
--      Anticheat Blox Fruits check velocity spike → nếu set CFrame tức thì + vel=0
--      → flag. Giải pháp: giữ AssemblyLinearVelocity nhỏ + tween (không tele spike).
--   6. WalkSpeed/JumpPower clamp — KHÔNG đổi (nhiều script bị ban vì set WS cao).
--   7. Anti-AFK                 — (ở mục 7) chống kick idle.
--   8. Random jitter            — hit delay random 0.05-0.08s → không đều như bot.

local function ElevateIdentity()
        pcall(function()
                local f = setthreadidentity or setidentity or set_thread_identity
                        or (syn and syn.set_thread_identity) or setthreadcontext
                if f then f(8) end
        end)
end

local OriginalStreaming = {}
pcall(function() OriginalStreaming.Enabled = workspace.StreamingEnabled end)
pcall(function() OriginalStreaming.MinRadius = workspace.StreamingMinRadius end)
pcall(function() OriginalStreaming.TargetRadius = workspace.StreamingTargetRadius end)

local function applyStreamingFix()
        -- Đây không phải lớp chống ban. Chỉ thử mở rộng streaming; game có thể từ chối.
        pcall(function() workspace.StreamingEnabled = false end)
        pcall(function()
                workspace.StreamingMinRadius = 5000
                workspace.StreamingTargetRadius = 5000
        end)
end

local function restoreStreamingFix()
        if OriginalStreaming.Enabled ~= nil then pcall(function() workspace.StreamingEnabled = OriginalStreaming.Enabled end) end
        if OriginalStreaming.MinRadius ~= nil then pcall(function() workspace.StreamingMinRadius = OriginalStreaming.MinRadius end) end
        if OriginalStreaming.TargetRadius ~= nil then pcall(function() workspace.StreamingTargetRadius = OriginalStreaming.TargetRadius end) end
end
if State.AntiBan then applyStreamingFix() end

-- SimulationRadius 5000 mỗi Heartbeat (giống BCH) + elevate identity 5s/lần
local _lastElevate = 0
table.insert(Connections, RunService.Heartbeat:Connect(function()
        if not State.AntiBan then return end
        pcall(function()
                if sethiddenproperty then
                        sethiddenproperty(LocalPlayer, "SimulationRadius", 5000)
                end
        end)
        local now = os.clock()
        if now - _lastElevate > 5 then
                _lastElevate = now
                ElevateIdentity()
        end
end))

-- ═══ ANTI-KICK (CẢI THIỆN: dùng hookmetamethod, KHÔNG setreadonly) ═══
-- Bản BCH/BCH cũ: getrawmetatable + setreadonly(false) → game có thể detect
-- (check mt readonly flag). Dùng hookmetamethod → KHÔNG đổi readonly → an toàn.
-- Chặn: LocalPlayer:Kick() + remote kick từ anticheat client.
local antiKickInstalled = false
local function installAntiKick()
        if antiKickInstalled then return end
        if not (hookmetamethod and newcclosure and getnamecallmethod) then return end
        local ok = pcall(function()
                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                        local method = getnamecallmethod()
                        if State.AntiKick and method == "Kick" and self == LocalPlayer then
                                return
                        end
                        return oldNamecall(self, ...)
                end))
        end)
        antiKickInstalled = ok
end
if State.AntiKick then installAntiKick() end

-- ═══ ANTI-TELEPORT-DETECT (chống anticheat phát hiện tele) ═══
-- Anticheat Blox Fruits check: nếu CFrame thay đổi lớn giữa 2 frame → velocity
-- spike → flag teleport. Giải pháp:
--   1. Tween (KHÔNG set CFrame tức thì) → di chuyển từng bước ≤ 230 studs/s.
--   2. Giữ AssemblyLinearVelocity = 0 mỗi frame (dập velocity → không spike).
--   3. FloatForce (BodyVelocity Velocity=0) → dập velocity liên tục.
-- → Tween + FloatForce = KHÔNG bị flag teleport.
-- (Đã implement trong MZ_Tween.to + FloatForce heartbeat — không cần thêm.)

-- ═══ WALKSPEED / JUMPPOWER CLAMP (chống ban do set太高) ═══
-- KHÔNG set WalkSpeed/JumpPower cao (nhiều script bị ban vì set WS 200+).
-- Chỉ giữ Humanoid defaults → anticheat không flag.
-- (KHÔNG thêm code set WS/JP — để game default.)

-- ═══ RANDOM JITTER (chống bot detect) ═══
-- Hit delay random 0.05-0.08s (đã có trong smashUntilDead) → không đều như bot.
-- Tween speed random ±10% (có thể thêm nếu cần).

-- Không queue tự quay về JobId cũ: khi Hop/Rejoin, code cũ sẽ chạy ở server mới
-- rồi teleport ngược lại server trước, dễ tạo vòng lặp chuyển server. Rejoin/Hop
-- hiện chỉ do nút người dùng chủ động gọi ở tab Khác.

-- ════════════════════════════ 4c. GHI CHÚ VỀ LỖI CONSOLE ═══════════════════
-- ⚠ KHÔNG HOOK `warn` (v2.6 từng hook → bị "văng game" vì hookfunction thay
--   hàm in-place → oldWarn trỏ vào hook → đệ quy vô hạn → stack overflow).
--   Các lỗi "PartType", "Jack o' Lantern parent locked", "VehicleSeat"...
--   đều là LỖI CỦA GAME (combat module / NPCStreaming), không phải script.
--   Chúng KHÔNG ảnh hưởng farm → cứ để console hiện, an toàn hơn hook.
-- (Nếu muốn ẩn: executor của bạn có tính năng filter console sẵn — dùng cái đó.)

-- ════════════════════════════ 5. TWEEN (mượn ý tưởng Banana Cat Hub) ══════
-- Tween theo Heartbeat: set CFrame từng bước theo tốc độ, có noclip,
-- chống kẹt (watchdog) và hủy được từ thread khác qua token.
local MZ_Tween = {
        token   = 0,
        running = false,
        owner   = nil,
}
-- (v5.1: xóa setFloatForce + _fv — dead code. FloatForce do heartbeat bên
--  dưới quản lý TẬP TRUNG: farm/trick BẬT → giữ LUÔN, TẮT → dọn sạch.)

-- ═══ FLOAT HOÀI (giống Banana Cat Hub auto farm) ═══
-- BCH giữ FloatForce (BodyVelocity Velocity=0, MaxForce=1e5) LUÔN BẬT khi farm
-- → nhân vật ĐỨNG YÊN TRÊN KHÔNG mãi, KHÔNG bao giờ rơi (gravity bị dập).
-- ⚠ Quan trọng: Float KHÔNG cản trở tween (BodyVelocity chỉ dập velocity, KHÔNG
-- chống set CFrame). Vậy float BẬT LUÔN khi farm on, kể cả khi tween đang chạy.
-- MỖI FRAME re-apply nếu bị xóa (character reset / game xóa) → không khoảng trống.
table.insert(Connections, RunService.Heartbeat:Connect(function()
        if Unloaded or not (State.FarmPumpkin or State.TrickOrTreat or State.Gacha or State.AutoHellfire or State.AutoWerewolf or State.AutoGreatPumpkin or State.AutoSummon or State.AutoSnowman or State.MysteryHall) then
                -- farm tắt → dọn float (nếu còn) để rơi/bơi bình thường
                local root = getRoot()
                if root then
                        local ff = root:FindFirstChild("MZ_FloatForce")
                        if ff then pcall(function() ff:Destroy() end) end
                end
                return
        end
        -- farm/trick BẬT → giữ FloatForce LUÔN (mỗi frame, không throttle)
        local root = getRoot()
        if root and not root:FindFirstChild("MZ_FloatForce") then
                pcall(function()
                        local fv = Instance.new("BodyVelocity")
                        fv.Name = "MZ_FloatForce"
                        fv.Velocity = Vector3.new(0, 0, 0)
                        fv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        fv.P = 1e5
                        fv.Parent = root
                end)
        end
end))

function MZ_Tween.cancel(owner)
        -- Một tính năng chỉ được hủy tween của chính nó; nil = unload/hủy toàn bộ.
        if owner and MZ_Tween.running and MZ_Tween.owner ~= owner then
                return false
        end
        MZ_Tween.token = MZ_Tween.token + 1
        MZ_Tween.running = false
        MZ_Tween.owner = nil
        return true
end

-- Raycast tìm MẶT NƯỚC dưới 1 điểm (chỉ nước, bỏ qua đất/roof/cây).
-- Trả về waterY (Y mặt nước) hoặc nil. Dùng cho safeStandPos/tween/tele.
-- ⚠ KHÔNG trả về đất/roof Y → tránh bump lên nóc nhà/ngọn cây.
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = false -- false để dò được mặt nước
local rayBuildClock = 0

local function groundwaterY(pos)
        local now = os.clock()
        if now - rayBuildClock > 2 then
                rayBuildClock = now
                local list = {}
                local c = getChar()
                if c then table.insert(list, c) end
                local folder = workspace:FindFirstChild("Characters")
                if folder then table.insert(list, folder) end
                RayParams.FilterDescendantsInstances = list
        end
        -- raycast từ trên xuống, dò điểm ĐẦU TIÊN chạm
        local hit = workspace:Raycast(
                Vector3.new(pos.X, pos.Y + 80, pos.Z),
                Vector3.new(0, -600, 0), RayParams)
        if hit and hit.Material == Enum.Material.Water then
                return hit.Position.Y
        end
        return nil
end

-- (v5.1: xóa wrapper groundYAt — dead code, không còn ai gọi. Mọi logic
--  chống nước đều dùng groundwaterY() trực tiếp.)

-- Trả về true nếu tới nơi (trong stopDist), false nếu hủy / kẹt / chết
-- groundSafe (mặc định BẬT): dọc đường bay tự giữ tối thiểu 3 studs trên
-- mặt đất / 3.5 studs trên mặt nước → KHÔNG bao giờ chui xuống biển nữa.
function MZ_Tween.to(targetCFrame, speed, stopDist, groundSafe, owner)
        local root = getRoot()
        local char = getChar()
        local hum = getHum()
        if not (root and char and hum) or typeof(targetCFrame) ~= "CFrame" then
                return false
        end

        owner = owner or "unowned"
        if MZ_Tween.running and MZ_Tween.owner ~= owner then
                return false
        end
        if MoveBus.owner ~= owner or MoveBus.thread ~= coroutine.running() then
                return false
        end
        MZ_Tween.cancel(owner)
        MZ_Tween.running = true
        MZ_Tween.owner = owner
        local myToken = MZ_Tween.token
        -- FloatForce do heartbeat quản lý (giữ LUÔN khi farm on) → KHÔNG tắt ở cuối tween
        -- (bản cũ tắt ở cuối → khoảng trống 0.5s → rơi xuống nước!)

        -- GIỚI HẠN tốc độ bay MAX 230 studs/s (yêu cầu owner) — vượt sẽ bị anticheat
        -- server kéo về + gây "tele chỗ không có bí ngô". Luôn kẹp trong [20, 230].
        speed = math.clamp(tonumber(speed) or 230, 20, 230)
        stopDist = tonumber(stopDist) or 4
        local goalPos = targetCFrame.Position
        local startTime = os.clock()
        local maxTime = (root.Position - goalPos).Magnitude / speed + 15 -- timeout an toàn
        local lastDist = math.huge
        local lastProgress = os.clock()

        local ok = false
        while MZ_Tween.running and myToken == MZ_Tween.token do
                local dt = RunService.Heartbeat:Wait()
                if MoveBus.owner == owner then MoveBus.since = os.clock() end
                local c = LocalPlayer.Character
                local r = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if not (c and r and h) or h.Health <= 0 or r.Parent ~= c then
                        break
                end
                if os.clock() - startTime > maxTime then
                        break
                end

                local cur = r.Position
                local delta = goalPos - cur
                local dist = delta.Magnitude

                -- watchdog chống kẹt: 5s không tiến bộ thì thoát
                if dist < lastDist - 1 then
                        lastDist = dist
                        lastProgress = os.clock()
                elseif os.clock() - lastProgress > 5 then
                        break
                end

                if dist <= stopDist then
                        r.CFrame = targetCFrame
                        ok = true
                        break
                end

                local step = math.min(speed * dt, dist)
                local newPos = cur + delta.Unit * step

                -- CHỐNG CHẠM NƯỚC (Devil Fruit): nếu điểm mới DƯỚI mặt nước
                -- → bump Y lên mặt nước + 2 studs. Đơn giản, KHÔNG scale XZ.
                -- FloatForce (heartbeat) đã dập velocity → không rơi → đủ rồi.
                if groundSafe ~= false then
                        local wY = groundwaterY(newPos)
                        if wY and newPos.Y < wY + 2 then
                                newPos = Vector3.new(newPos.X, wY + 2, newPos.Z)
                        end
                end

                r.CFrame = CFrame.new(newPos)
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end

        -- KHÔNG tắt FloatForce ở cuối tween — heartbeat giữ LUÔN khi farm on
        if myToken == MZ_Tween.token then
                MZ_Tween.running = false
                MZ_Tween.owner = nil
        end
        return ok
end

-- ═════════════ 5b. MOVE BUS — GIỚI HẠN QUYỀN DI CHUYỂN (v5.1) ═════════════
-- Fix "Farm và Trick-or-Treat tranh nhau kéo nhân vật": chỉ MỘT tính năng
-- được điều khiển di chuyển tại 1 thời điểm. Mỗi loop GIỮ bus trong 1 đơn vị
-- công việc (farm: 1 bí ngô — TnT: 1 cửa — boss: 1 chu kỳ đánh — gacha: 1 lượt
-- roll — hall: 1 lượt quét) rồi NHẢ ra cho loop khác xen vào xen kẽ.

local function moveAcquire(id, waitMax)
        local deadline = os.clock() + (waitMax or 20)
        local currentThread = coroutine.running()
        while os.clock() < deadline and not Unloaded do
                if MoveBus.owner == nil then
                        MoveBus.owner = id
                        MoveBus.thread = currentThread
                        MoveBus.since = os.clock()
                        return true
                end
                -- Thu hồi quyền chỉ khi lease thật sự bị treo (không được gia hạn).
                if os.clock() - MoveBus.since > 90 then
                        MoveBus.owner = id
                        MoveBus.thread = currentThread
                        MoveBus.since = os.clock()
                        return true
                end
                -- Chỉ thread đã sở hữu lease mới được tái xác nhận nó.
                if MoveBus.owner == id and MoveBus.thread == currentThread then
                        MoveBus.since = os.clock()
                        return true
                end
                task.wait(0.1)
        end
        return false
end

local function moveRelease(id)
        if MoveBus.owner == id and MoveBus.thread == coroutine.running() then
                MoveBus.owner = nil
                MoveBus.thread = nil
                MoveBus.since = 0
        end
end

local function moveTouch(id)
        if MoveBus.owner == id and MoveBus.thread == coroutine.running() then
                MoveBus.since = os.clock()
        end
end

-- ═══ 5c. KHÔI PHỤC COLLISION (v5.1 — tắt noclip / unload) ═══
-- Trước đây tắt noclip / unload KHÔNG khôi phục CanCollide → nhân vật "ma"
-- xuyên đất tới khi respawn. Giờ bật lại collision cho các part THÂN
-- (không đụng HumanoidRootPart — bản chất CanCollide=false, và accessory).
local RESTORE_PARTS = {
        Head = true, Torso = true,
        LeftArm = true, RightArm = true, LeftLeg = true, RightLeg = true,
        UpperTorso = true, LowerTorso = true,
        LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
        RightUpperArm = true, RightLowerArm = true, RightHand = true,
        LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
        RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
}

local function restoreCollisions()
        for part, originalValue in pairs(OriginalCollision) do
                if part and part.Parent then
                        pcall(function() part.CanCollide = originalValue end)
                end
                OriginalCollision[part] = nil
        end
end

-- ════════════════════════════ 6. NOCLIP (bản nhẹ — giảm lag) ══════════════
-- Bản cũ cache parts 1s/lần → phần mới (Accessory, Tool) không được disable
-- → kẹt trong tường. Bản mới: quét GetDescendants MỖI FRAME trên Stepped
-- (trước physics) → CanCollide = false trên TẤT CẢ BasePart.
-- KHÔNG cache → không stale, chắc chắn xuyên được tường/nóc/cây.
-- Tối ưu: character chỉ ~30 part → GetDescendants rất rẻ (<0.05ms).
table.insert(Connections, RunService.Stepped:Connect(function()
        if Unloaded or not State.Noclip then return end
        -- Noclip chỉ hoạt động trong lúc một automation cần xuyên vật cản.
        local automationActive = State.FarmPumpkin or State.TrickOrTreat or State.Gacha
                or State.AutoHellfire or State.AutoWerewolf or State.AutoGreatPumpkin
                or State.AutoSummon or State.AutoSnowman or State.MysteryHall
        if not automationActive then
                if next(OriginalCollision) ~= nil then restoreCollisions() end
                return
        end
        local c = LocalPlayer.Character
        if not c then return end
        for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then
                        if OriginalCollision[part] == nil then
                                OriginalCollision[part] = part.CanCollide
                        end
                        if part.CanCollide then part.CanCollide = false end
                end
        end
end))

-- ════════════════════════════ 7. ANTI-AFK ═════════════════════════════════
table.insert(Connections, LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
                pcall(function()
                        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                        task.wait(1)
                        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
        end
end))

-- ════════════════════════════ 8. REMOTE FAST ATTACK ═══════════════════════
-- Copy ĐÚNG pattern Banana Cat Hub (meizublf.lua):
--   local Net   = require(RS.Modules.Net)
--   local Mouse = require(RS.Mouse)
--   local CombatUtil = require(RS.Modules.CombatUtil)
--   local RegisterAttack = RS.Modules.Net:WaitForChild("RE/RegisterAttack")
--   local RegisterHit    = Net:RemoteEvent("RegisterHit", true)
-- ⚠ Bản cũ gọi Net:RemoteEvent() trên ModuleScript INSTANCE → lỗi (ModuleScript
--   không có method :RemoteEvent). Phải require() ra TABLE trước rồi mới gọi.
local RegisterAttack, RegisterHit, CombatUtil, MouseSwing, NetModule
do
        pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                local netModule = RS:WaitForChild("Modules", 9):WaitForChild("Net", 9)
                -- require ra TABLE (giống BCH: local m = require(...Modules.Net))
                pcall(function()
                        NetModule = require(netModule)
                end)
                -- RegisterAttack: lấy từ instance (giống BCH: Net:WaitForChild("RE/RegisterAttack"))
                RegisterAttack = netModule:WaitForChild("RE/RegisterAttack", 9)
                -- RegisterHit: qua NetModule:RemoteEvent() (giống BCH: m:RemoteEvent("RegisterHit", true))
                if NetModule and type(NetModule.RemoteEvent) == "function" then
                        local ok = pcall(function()
                                RegisterHit = NetModule:RemoteEvent("RegisterHit", true)
                        end)
                        if not ok or not RegisterHit then
                                RegisterHit = netModule:WaitForChild("RE/RegisterHit", 9)
                        end
                else
                        -- fallback: lấy trực tiếp instance
                        RegisterHit = netModule:WaitForChild("RE/RegisterHit", 9)
                end
        end)
        pcall(function()
                CombatUtil = require(game:GetService("ReplicatedStorage")
                        :WaitForChild("Modules"):WaitForChild("CombatUtil"))
        end)
        pcall(function()
                local mm = require(game:GetService("ReplicatedStorage"):WaitForChild("Mouse", 9))
                if type(mm) == "table" and type(mm.FireServer) == "function" then
                        MouseSwing = mm -- thiếu gói này server có thể từ chối damage!
                end
        end)
        if not RegisterHit then
                warn("[MZ Halloween] Không tìm thấy remote RegisterHit → dùng fallback M1 thường")
        end
end

-- ════════════════════════════ 9. QUÉT MAP (CACHE DUY NHẤT — GIẢM LAG) ═════
-- Bí ngô = Model tên "Pumpkin" (theo ESP gốc của bạn). PumpkinPatch = mốc vùng.
-- ⚠ GIẢM LAG: trước đây farm / ESP / nhặt đồ / prompt MỖI CÁI tự chạy
-- workspace:GetDescendants() → quét cả map 5-10 lần/giây → lag nặng.
-- Giờ chỉ có 1 bảng cache duy nhất: cả game tối đa quét 1 lần / 1.2s,
-- mọi tính năng (farm, ESP, nhặt đồ, gõ cửa, gacha, đếm) đọc từ đây.
local MZ_World = {
        built    = 0,
        sig      = "",
        pumpkins = {},
        patches  = {},
        drops    = {},
        prompts  = {},
        clickers = {},
}
local blacklist = {} -- [model] = THỜI ĐIỂM HẾT HẠN ban (quả giả 120s / khó tới 30s)

local function splitCsv(csv)
        local list = {}
        for kw in (csv or ""):lower():gmatch("[^,]+") do
                kw = kw:match("^%s*(.-)%s*$")
                if kw ~= "" then table.insert(list, kw) end
        end
        return list
end

local function matchKeyword(text, csv)
        text = (text or ""):lower()
        for kw in (csv or ""):lower():gmatch("[^,]+") do
                kw = kw:match("^%s*(.-)%s*$")
                if kw ~= "" and text:find(kw, 1, true) then
                        return true
                end
        end
        return false
end

-- Chỉ loại part thuộc mô hình bí ngô/NPC thật; KHÔNG loại nhầm model loot
-- như "Pumpkin Bits" hoặc "Cursed Pumpkin Seed".
local function isPumpkinModelPart(p)
        local anc = p and p:FindFirstAncestorOfClass("Model")
        while anc do
                local compact = (anc.Name or ""):lower():gsub("[^%w]", "")
                if compact == "pumpkin" or compact:find("jackolantern", 1, true)
                        or compact == "pumpkinsnowman"
                        or (function()
                                local ok, tagged = pcall(function()
                                        return anc:GetAttribute("MZ_HalloweenPumpkin") == true
                                                or CollectionService:HasTag(anc, "MZ_HalloweenPumpkin")
                                end)
                                return ok and tagged
                        end)() then
                        return true
                end
                anc = anc:FindFirstAncestorOfClass("Model")
        end
        return false
end

local function worldSignature()
        return (State.PickupKeywords or "") .. "|" .. (State.KnockKeywords or "")
                .. "|" .. (State.GachaKeywords or "") .. "|" .. (State.FilterMode or "")
end

local pickupKw = splitCsv(State.PickupKeywords)

-- Có thể đánh dấu mục tiêu trong experience của bạn bằng tag/attribute này.
-- Pumpkin không được đánh dấu chỉ hợp lệ nếu nằm trong vùng PumpkinPatch.
local EVENT_PUMPKIN_TAG = "MZ_HalloweenPumpkin"
local EVENT_PATCH_TAG = "MZ_HalloweenPumpkinPatch"

local function hasEventMarker(instance, tagName)
        if not instance then return false end
        local marked = false
        pcall(function()
                marked = instance:GetAttribute(tagName) == true
                        or CollectionService:HasTag(instance, tagName)
        end)
        return marked
end

local function refreshPumpkins(force)
        local now = os.clock()
        local sig = worldSignature()
        if not force and (now - MZ_World.built) < 1.2 and MZ_World.sig == sig then
                return MZ_World.pumpkins
        end
        MZ_World.built = now
        MZ_World.sig = sig
        pickupKw = splitCsv(State.PickupKeywords)

        local pumpkins, patches, drops, prompts, clickers = {}, {}, {}, {}, {}
        local seenDropContainers = {}
        local myChar = LocalPlayer.Character
        for _, d in ipairs(workspace:GetDescendants()) do
                local cls = d.ClassName
                if cls == "Model" then
                        local ln = d.Name:lower()
                        local compactName = ln:gsub("[^%w]", "")
                        if compactName:find("pumpkinpatch", 1, true)
                                or hasEventMarker(d, EVENT_PATCH_TAG) then
                                table.insert(patches, d)
                        elseif compactName == "pumpkin"
                                or compactName:find("jack", 1, true)
                                or hasEventMarker(d, EVENT_PUMPKIN_TAG) then
                                table.insert(pumpkins, d)
                        end
                elseif cls == "ProximityPrompt" then
                        table.insert(prompts, d)
                elseif cls == "ClickDetector" then
                        -- cửa nhà Trick-or-Treat có thể dùng ClickDetector (không phải Prompt)
                        table.insert(clickers, d)
                elseif cls == "BasePart" and #pickupKw > 0 then
                        if not (myChar and d:IsDescendantOf(myChar)) and not isPumpkinModelPart(d) then
                                -- Loot thường là Model/Tool tên "Pumpkin Bits" nhưng part
                                -- bên trong chỉ tên Handle. So cả tên container gần nhất.
                                local matchedNode = nil
                                local node = d
                                for depth = 0, 4 do
                                        if node and (node == d or node:IsA("Model") or node:IsA("Tool"))
                                                and matchKeyword(node.Name, State.PickupKeywords) then
                                                matchedNode = node
                                                break
                                        end
                                        node = node and node.Parent or nil
                                end
                                if matchedNode then
                                        local nearestContainer = d:FindFirstAncestorOfClass("Tool")
                                                or d:FindFirstAncestorOfClass("Model")
                                        local container = (matchedNode:IsA("Model") or matchedNode:IsA("Tool"))
                                                and matchedNode or nearestContainer
                                        local key = container or d
                                        if not seenDropContainers[key] then
                                                seenDropContainers[key] = true
                                                local touchPart = d
                                                if container and container:IsA("Model") then
                                                        touchPart = container.PrimaryPart
                                                                or container:FindFirstChildWhichIsA("BasePart", true)
                                                                or d
                                                elseif container and container:IsA("Tool") then
                                                        touchPart = container:FindFirstChild("Handle")
                                                                or container:FindFirstChildWhichIsA("BasePart")
                                                                or d
                                                end
                                                if touchPart and touchPart:IsA("BasePart") then
                                                        table.insert(drops, touchPart)
                                                end
                                        end
                                end
                        end
                end
        end

        MZ_World.pumpkins = pumpkins
        MZ_World.patches  = patches
        MZ_World.drops    = drops
        MZ_World.prompts  = prompts
        MZ_World.clickers = clickers

        -- dọn blacklist ĐÃ HẾT HẠN (t = thời điểm hết hạn)
        for m, t in pairs(blacklist) do
                if now > t or m.Parent == nil then
                        blacklist[m] = nil
                end
        end
        return pumpkins
end

local function modelRoot(model)
        if not model then return nil end
        return model.PrimaryPart
                or model:FindFirstChild("HumanoidRootPart", true)
                or model:FindFirstChild("RootPart", true)
                or model:FindFirstChildWhichIsA("BasePart", true)
end

local PATCH_PADDING = 35
local PATCH_FALLBACK_RADIUS = 140

local function pumpkinInsidePatch(pumpkinRoot, patch)
        if not (pumpkinRoot and patch and patch.Parent) then return false end
        local ok, boxCFrame, boxSize = pcall(function()
                return patch:GetBoundingBox()
        end)
        if ok and boxCFrame and boxSize and boxSize.Magnitude > 0 then
                local localPos = boxCFrame:PointToObjectSpace(pumpkinRoot.Position)
                local verticalPadding = math.max(boxSize.Y * 0.5 + PATCH_PADDING, 80)
                return math.abs(localPos.X) <= boxSize.X * 0.5 + PATCH_PADDING
                        and math.abs(localPos.Z) <= boxSize.Z * 0.5 + PATCH_PADDING
                        and math.abs(localPos.Y) <= verticalPadding
        end
        local patchRoot = modelRoot(patch)
        return patchRoot ~= nil
                and (pumpkinRoot.Position - patchRoot.Position).Magnitude <= PATCH_FALLBACK_RADIUS
end

-- patchHasAny (cache 1.2s): có ÍT NHẤT 1 bí ngô nằm trong PumpkinPatch không?
-- = false (không có patch nào, hoặc patch có nhưng rỗng) → isEventPumpkinTarget
--   FALLBACK: chấp nhận mọi bí ngô tên "Pumpkin" (TRÁNH "bật farm không đi" khi
--   game không có model PumpkinPatch hoặc detection không khớp).
-- = true → chỉ farm bí ngô trong patch (loại bí ngô trang trí).
local _patchHasAnyCache, _patchHasAnyClock = nil, 0
local function patchHasAny(patches)
        local now = os.clock()
        if _patchHasAnyCache ~= nil and now - _patchHasAnyClock < 1.2 then
                return _patchHasAnyCache
        end
        _patchHasAnyClock = now
        _patchHasAnyCache = false
        if not patches or #patches == 0 then return false end
        for _, m in ipairs(MZ_World.pumpkins) do
                local r = modelRoot(m)
                if r then
                        for _, patch in ipairs(patches) do
                                if pumpkinInsidePatch(r, patch) then
                                        _patchHasAnyCache = true
                                        return true
                                end
                        end
                end
        end
        return _patchHasAnyCache
end

-- Kiểm tra model có nằm trong workspace.Enemies không ( = quái thật, có Humanoid).
-- Quái Jack o' Lantern ở đây → dùng FAST ATTACK (remote) kiểu Banana Cat Hub.
local function isWorkspaceEnemy(model)
        if not model or not model.Parent then return false end
        local anc = model
        while anc and anc ~= workspace do
                if anc.Name == "Enemies" and anc.Parent == workspace then return true end
                anc = anc.Parent
        end
        return false
end

local function isEventPumpkinTarget(model, rootPart, patches)
        if hasEventMarker(model, EVENT_PUMPKIN_TAG) then return true end
        -- Quái Jack o' Lantern trong workspace.Enemies → LUÔN là mục tiêu hợp lệ
        -- (dùng fast attack, không cần nằm trong PumpkinPatch)
        if isWorkspaceEnemy(model) then return true end
        -- KHÔNG có patch nào, hoặc patch có nhưng KHÔNG chứa bí ngô nào
        -- → FALLBACK: chấp nhận mọi bí ngô (fix "bật farm không đi")
        if not patches or #patches == 0 or not patchHasAny(patches) then
                return true
        end
        for _, patch in ipairs(patches) do
                if pumpkinInsidePatch(rootPart, patch) then return true end
        end
        return false
end

local function withinFarmRadius(position, origin)
        if not origin then return true end
        return (position - origin).Magnitude <= (tonumber(State.MaxFarmDistance) or 350)
end

local function pumpkinValid(model, fromPos)
        if not model or model.Parent == nil then return false end
        local bl = blacklist[model]
        if bl and os.clock() < bl then return false end
        local r = modelRoot(model)
        if not r then return false end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return false end
        if State.FilterMode == "Bỏ qua bí ngô sống/boss" and hum and hum.MaxHealth >= 1000 then
                return false
        end
        return true
end

-- ════════════════════════════ 10. VŨ KHÍ & ĐÁNH ═══════════════════════════
local STYLE_NAMES = {
        "Combat", "Black Leg", "Electro", "Fishman Karate", "Dragon Talon",
        "Superhuman", "Electric Claw", "Death Step", "Sharkman Karate",
        "Godhuman", "Sanguine Art",
}

-- khớp theo TÊN hoặc TOOLTIP (nhiều executor để ToolTip rỗng)
local function isStyleTool(t)
        if not t then return false end
        local n = ((t.Name or "") .. " " .. (t.ToolTip or "")):lower()
        for _, name in ipairs(STYLE_NAMES) do
                if n:find(name:lower(), 1, true) then return true end
        end
        return false
end

local function equippedStyle()
        local char = getChar()
        local held = char and char:FindFirstChildOfClass("Tool")
        if held and isStyleTool(held) then return held end
        return nil
end

local StyleNotFoundNotified = false

local function equipFightingStyle()
        local char = getChar()
        local hum = getHum()
        if not (char and hum) or hum.Health <= 0 then return end
        if equippedStyle() then return end -- đang cầm đúng style → khỏi equip lại

        local tool
        for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and isStyleTool(t) then tool = t break end
        end
        if not tool then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                        for _, t in ipairs(bp:GetChildren()) do
                                if t:IsA("Tool") and isStyleTool(t) then tool = t break end
                        end
                end
        end
        if tool and not hum.Sit then
                pcall(function() hum:EquipTool(tool) end)
        elseif not tool and not StyleNotFoundNotified then
                StyleNotFoundNotified = true
                notify("Fighting Style", "Không thấy Fighting Style trong nhân vật/túi → M1 có thể không ăn. Hãy trang bị Combat trở lên!", "warning")
        end
end

local function faceTarget(pos)
        local root = getRoot()
        if not root then return end
        local flat = Vector3.new(pos.X, root.Position.Y, pos.Z)
        if (flat - root.Position).Magnitude > 0.5 then
                pcall(function()
                        root.CFrame = CFrame.lookAt(root.Position, flat)
                end)
        end
end

-- quay camera nhìn về bí ngô để cú M1 ảo ăn đúng mục tiêu
local function aimCamera(pos)
        pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, pos)
                end
        end)
end

-- "ảnh chụp" bí ngô để biết cú đánh có ăn máu không (máu giảm / part biến mất)
local function pumpkinSnapshot(model)
        local s = { parts = 0, health = nil }
        pcall(function()
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum then s.health = hum.Health end
                for _, p in ipairs(model:GetDescendants()) do
                        if p:IsA("BasePart") then
                                s.parts = s.parts + 1
                        end
                end
        end)
        return s
end

local function snapshotChanged(a, b)
        if not a or not b then return true end
        if a.health and b.health and math.abs(a.health - b.health) > 0.01 then return true end
        if a.parts ~= b.parts then return true end
        return false
end

-- Cách đánh: MẶC ĐỊNH "m1" = giả lập NGƯỜI THẬT (server chỉ cộng damage khi
-- đánh như người chơi thật). "remote" chỉ dùng khi bật toggle riêng.
local AtkMethod = State.FastAttack and "remote" or "m1"

-- Đánh bằng remote — GIỐNG HỆT gói người chơi thật:
--   1) Mouse:FireServer(0.35) → đăng ký cú vung, mở "cửa sổ đánh" phía server
--   2) RegisterHit:FireServer(partĐầu, list cặp {rig, part})
-- Part không resolve được rig sẽ KHÔNG được gửi (game thật cũng không bao giờ
-- gửi part không rig → tránh lỗi "unknown index from name=PartType").
local function hitPumpkinRemote(model, myPos)
        if not (RegisterHit and CombatUtil) then return false end
        local hitList = {}
        for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") and (p.Position - myPos).Magnitude <= State.HitRange + 15 then
                        local rig = nil
                        pcall(function()
                                rig = CombatUtil:GetRigOfHitPart(p)
                        end)
                        if rig then
                                table.insert(hitList, { rig, p })
                        end
                end
        end
        if #hitList == 0 then return false end
        local first = table.remove(hitList, 1)
        return pcall(function()
                if MouseSwing then
                        MouseSwing:FireServer(0.35) -- đăng ký cú vung TRƯỚC như người chơi thật
                end
                if RegisterAttack then
                        RegisterAttack:FireServer(0)
                end
                RegisterHit:FireServer(first[2], hitList)
        end)
end

-- ═══ FAST ATTACK CHO QUÁI JACK O' LANTERN (COPY ĐÚNG BCH Attack No Anim) ═══
-- Copy NGUYÊN cơ chế farm của Banana Cat Hub:
--   1) getBladeHits: quét TẤT CẢ quái trong workspace.Enemies (trong range),
--      thu thập BasePart của mỗi con → AOE đánh NHIỀU quái 1 phát.
--   2) AttackAOE: lọc part theo BODY_PARTS + GetRigOfHitPart + IsVulnerable.
--   3) RegisterAttack:FireServer(0) + RegisterHit:FireServer(firstPart, hitList)
--      → no-animation, đánh NHANH.
-- ⚠ TOÀN BỘ pcall → bất kỳ lỗi nào (CombatUtil thay đổi / remote thiếu) cũng
--   chỉ return false → fallback M1, KHÔNG bao giờ crash script.
local BODY_PARTS = {
        -- R6
        Head = true, Torso = true, LeftArm = true, RightArm = true,
        LeftLeg = true, RightLeg = true,
        -- R15
        UpperTorso = true, LowerTorso = true,
        LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
        RightUpperArm = true, RightLowerArm = true, RightHand = true,
        LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
        RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
        -- chung
        HumanoidRootPart = true,
}

-- getBladeHits: quét TẤT CẢ quái trong workspace.Enemies (+ Characters nếu includeChars)
-- có HRP trong range → thu thập BasePart. (Copy y hệt BCH getgenv().getBladeHits)
local function getBladeHits(myChar, myHRP, radius, includeChars, allowedModels)
        local results = {}
        local rad = radius or 80
        local enemies = workspace:FindFirstChild("Enemies")
        local targets = {}
        if enemies then
                for _, e in ipairs(enemies:GetChildren()) do
                        table.insert(targets, e)
                end
        end
        if includeChars then
                local chars = workspace:FindFirstChild("Characters")
                if chars then
                        for _, c in ipairs(chars:GetChildren()) do
                                table.insert(targets, c)
                        end
                end
        end
        for _, model in ipairs(targets) do
                if model ~= myChar and model:IsDescendantOf(workspace)
                        and (not allowedModels or allowedModels[model])
                        and model:FindFirstChild("HumanoidRootPart") then
                        local eHRP = model.HumanoidRootPart
                        local r = rad + (eHRP.Size.X / 2)
                        -- check HRP trong range (giống BCH: 10 + d + Size.X/2)
                        if (eHRP.Position - myHRP.Position).Magnitude <= 10 + r then
                                -- thu thập BasePart con trong range (giống BCH function m)
                                for _, p in ipairs(model:GetDescendants()) do
                                        if p:IsA("BasePart")
                                                and (p.Position - myHRP.Position).Magnitude <= r then
                                                table.insert(results, p)
                                        end
                                end
                        end
                end
        end
        return results
end

-- AttackAOE: lọc parts theo BODY_PARTS + GetRigOfHitPart + IsVulnerable
-- Trả về list { rig, part } — 1 rig/quái (giống BCH AttackAOE)
local function attackAOE(radius, includeChars, allowedModels)
        if not CombatUtil then return nil end
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil end
        local allParts = getBladeHits(myChar, myHRP, radius, includeChars, allowedModels)
        local hitList = {}
        local seenRig = {}
        for _, p in ipairs(allParts) do
                if BODY_PARTS[p.Name] then
                        local rig = nil
                        pcall(function() rig = CombatUtil:GetRigOfHitPart(p) end)
                        local vuln = true
                        if rig and CombatUtil.IsVulnerable then
                                pcall(function() vuln = CombatUtil:IsVulnerable(rig) end)
                        end
                        if rig and not seenRig[rig] and vuln then
                                table.insert(hitList, { rig, p })
                                seenRig[rig] = true
                        end
                end
        end
        return #hitList > 0 and hitList or nil
end

-- AttackFunction (Attack No Animation): copy y hệt BCH
-- RegisterAttack:FireServer(0) + RegisterHit:FireServer(firstPart, hitList)
local function hitEnemiesFastAttack(allowedModels)
        -- GUARD: thiếu remote → return false (fallback M1)
        if not RegisterHit or not RegisterAttack then return false end
        local hitList = attackAOE(State.HitRange or 80, false, allowedModels)
        if not hitList or #hitList == 0 then return false end
        local first = table.remove(hitList, 1)
        local ok = pcall(function()
                RegisterAttack:FireServer(0)
                RegisterHit:FireServer(first[2], hitList)
        end)
        -- cleanup thủ công (table.clear không có ở Lua 5.1 thuần)
        for i = 1, #hitList do hitList[i] = nil end
        return ok
end

-- Wrapper cho doHit gọi (1 target → vẫn AOE tất cả quái quanh đó)
local function hitEnemyFastAttack(model)
        if not model then return false end
        return hitEnemiesFastAttack({ [model] = true })
end

-- Kiểm tra 1 điểm màn hình có nằm TRONG cửa sổ Hub không (Hub nằm trong
-- CoreGui nên GetGuiObjectsAtPosition không thấy → phải tự soi bounds)
local function pointInHub(x, y)
        local ok, res = pcall(function()
                local sg = Library and Library._ScreenGui
                if not sg or not sg.Enabled then return false end
                for _, f in ipairs(sg:GetChildren()) do
                        if f:IsA("Frame") and f.Visible
                                and f.AbsoluteSize.X > 50 and f.AbsoluteSize.Y > 30 then
                                local px, py = f.AbsolutePosition.X, f.AbsolutePosition.Y
                                if x >= px and x <= px + f.AbsoluteSize.X
                                        and y >= py and y <= py + f.AbsoluteSize.Y then
                                        return true
                                end
                        end
                end
                return false
        end)
        return ok and res or false
end

-- Tìm điểm click TRỐNG trên màn hình (không có UI nào nằm dưới đó).
-- ⚠ FIX LỖI "FARM TỰ TẮT": bản cũ click NGAY GIỮA MÀN HÌNH — cú click ảo
-- rơi trúng cửa sổ Hub đang mở → tự bấm trúng toggle Farm → farm tắt!
local function safeClickPoint()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local vp = cam.ViewportSize
        local candidates = {
                Vector2.new(vp.X * 0.50, vp.Y * 0.50),
                Vector2.new(vp.X * 0.50, vp.Y * 0.40),
                Vector2.new(vp.X * 0.50, vp.Y * 0.60),
                Vector2.new(vp.X * 0.38, vp.Y * 0.50),
                Vector2.new(vp.X * 0.62, vp.Y * 0.50),
                Vector2.new(vp.X * 0.30, vp.Y * 0.38),
                Vector2.new(vp.X * 0.70, vp.Y * 0.38),
                Vector2.new(vp.X * 0.30, vp.Y * 0.62),
                Vector2.new(vp.X * 0.70, vp.Y * 0.62),
                Vector2.new(vp.X * 0.20, vp.Y * 0.50),
                Vector2.new(vp.X * 0.80, vp.Y * 0.50),
                Vector2.new(vp.X * 0.08, vp.Y * 0.50),
                Vector2.new(vp.X * 0.92, vp.Y * 0.50),
        }
        for _, c in ipairs(candidates) do
                local blocked = pointInHub(c.X, c.Y)
                if not blocked then
                        local okG, guis = pcall(function()
                                return UserInputService:GetGuiObjectsAtPosition(c.X, c.Y)
                        end)
                        if okG and type(guis) == "table" and #guis > 0 then
                                blocked = true
                        end
                end
                if not blocked then
                        return c
                end
        end
        return nil -- màn hình bị UI che kín → dùng fallback Activate
end

-- M1 GIẢ LẬP NGƯỜI THẬT (bản cũ bấm 0ms tại giữa màn hình → không ăn damage
-- và tự bấm nhầm UI). Bản mới:
--   • di chuyển chuột tới điểm trống → NHẤN GIỮ 40-90ms → nhả (như tay thật)
--   • jitter ±8px mỗi phát như người thật
--   • không có VIM / màn hình kín UI → fallback tool:Activate()
local function hitPumpkinM1(aimPos)
        aimCamera(aimPos)
        if VIM then
                local pt = safeClickPoint()
                if pt then
                        local x = pt.X + math.random(-8, 8)
                        local y = pt.Y + math.random(-6, 6)
                        pcall(function()
                                VIM:SendMouseMoveEvent(x, y, game)
                        end)
                        task.wait(0.02)
                        pcall(function()
                                VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                        end)
                        task.wait(0.04 + math.random() * 0.05) -- giữ chuột như người thật
                        pcall(function()
                                VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
                        end)
                        return
                end
        end
        local char = getChar()
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
                pcall(function() tool:Activate() end)
        end
end

-- Điểm vào duy nhất: TỰ ĐỘNG chọn cách đánh theo loại mục tiêu:
--   • Quái Jack o' Lantern (workspace.Enemies) → FAST ATTACK AOE kiểu BCH
--     (đánh TẤT CẢ quái trong range cùng lúc — Attack No Animation)
--   • Pumpkin (bí ngô sự kiện) → M1 giả lập người thật (luôn M1, ổn định)
local function doHit(model, aimPos, myPos)
        -- Quái Jack o' Lantern → fast attack AOE (BCH style) — LUÔN dùng
        if isWorkspaceEnemy(model) then
                if hitEnemyFastAttack(model) then
                        return "remote"
                end
                -- fast attack fail (server chặn / chưa load remote) → fallback M1
                hitPumpkinM1(aimPos)
                return "m1"
        end
        -- Pumpkin (sự kiện) → M1 giả lập người thật (mặc định).
        -- Chỉ dùng remote cho pumpkin nếu owner bật toggle (thường server chặn).
        if AtkMethod == "remote" and hitPumpkinRemote(model, myPos or aimPos) then
                return "remote"
        end
        hitPumpkinM1(aimPos)
        return "m1"
end

-- ════════════════════════════ 10b. AUTO BUSO HAKI ═════════════════════════
-- Mượn kỹ thuật Banana Cat Hub: khi Buso BẬT, nhân vật có con _BusoLayer1
-- (layer aura) hoặc HasBuso → chưa có thì CommF_:InvokeServer("Buso").
local CommF = nil
pcall(function()
        CommF = game:GetService("ReplicatedStorage")
                :WaitForChild("Remotes", 9):WaitForChild("CommF_", 9)
end)

local function ffcMatch(container, pattern)
        if not container then return nil end
        for _, c in ipairs(container:GetChildren()) do
                if string.match(c.Name, pattern) then return c end
        end
        return nil
end

-- true = Buso đang BẬT (char chưa load → coi như bật để khỏi spam remote)
local function busoActive()
        local c = getChar()
        if not c then return true end
        return ffcMatch(c, "_BusoLayer1") ~= nil
                or c:FindFirstChild("HasBuso") ~= nil
end

local function enableBuso()
        if not CommF then return false end
        if not busoActive() then
                return pcall(function() CommF:InvokeServer("Buso") end)
        end
        return true
end

local BusoGen = 0
local busoFails, busoWarned = 0, false

local function busoLoop()
        BusoGen = BusoGen + 1
        local myGen = BusoGen
        while State.AutoBuso and myGen == BusoGen do
                local ok, err = pcall(function()
                        local c = getChar()
                        if c and not busoActive() then
                                enableBuso()
                                task.wait(1.5)
                                if busoActive() then
                                        busoFails = 0
                                else
                                        busoFails = busoFails + 1
                                        if busoFails >= 3 and not busoWarned then
                                                busoWarned = true
                                                notify("Auto Buso",
                                                        "Không bật được Buso — có thể bạn CHƯA MUA Haki Buso ($25.000 Beli) hoặc đang hết năng lượng Haki.",
                                                        "warning")
                                        end
                                end
                        end
                end)
                if not ok then
                        warn("[MZ Halloween] busoLoop lỗi (tự tiếp tục): " .. tostring(err))
                end
                task.wait(1)
        end
end

-- ════════════════════════════ 11. AUTO FARM BÍ NGÔ ════════════════════════
-- Điểm đứng KẾ BEN bí ngô (clean, giống BCH):
--   • Dùng Y của bí ngô (đứng ngang tầm — vào trong nhà, dưới cây).
--   • CHỈ bump Y khi điểm đứng DƯỚI mặt nước (Devil Fruit chạm nước = chết).
--   • KHÔNG bump cho đất/roof/cây → noclip xuyên, KHÔNG lên nóc.
local function safeStandPos(pos)
        local wY = groundwaterY(pos)
        local baseY = pos.Y
        if wY and baseY < wY + 2 then
                baseY = wY + 2 -- trên mặt nước 2 studs (an toàn Devil Fruit)
        end
        return Vector3.new(pos.X, baseY, pos.Z)
end

-- Điểm đứng CHO QUÁI (BCH farm style): bay CAO trên đầu quái để đánh.
--   • Vị trí = trên đầu quái (quái.Y + EnemyStandY, lệch XZ EnemyStandDist).
--   • KHÔNG bump nước ở đây (đã cao rồi, không chạm nước).
local function safeStandPosEnemy(enemyPos)
        local x = enemyPos.X
        local y = enemyPos.Y + (State.EnemyStandY or 25) -- bay cao trên đầu
        local z = enemyPos.Z
        return Vector3.new(x, y, z)
end

-- TELEPORT (set CFrame tức thì) — giống BCH farm. CHỐNG CHẠM NƯỚC:
-- nếu điểm tele DƯỚI mặt nước → bump Y lên mặt nước + 2 studs.
local function MZ_Teleport(targetPos, owner)
        local root = getRoot()
        owner = owner or "unowned"
        if MoveBus.owner ~= owner or MoveBus.thread ~= coroutine.running() then return false end
        if not MoveBus.owner then return false end -- tele chỉ được gọi khi đã giữ MoveBus
        if not root then return false end
        local goalPos = targetPos
        if typeof(targetPos) == "CFrame" then
                goalPos = targetPos.Position
        end
        if typeof(goalPos) ~= "Vector3" then return false end
        local finalY = goalPos.Y
        local wY = groundwaterY(goalPos)
        if wY and finalY < wY + 2 then
                finalY = wY + 2
        end
        local moved = pcall(function()
                root.CFrame = CFrame.new(goalPos.X, finalY, goalPos.Z)
        end)
        if not moved then return false end
        pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
        return true
end

-- CHỐNG CHẠM NƯỚC: đã xử lý TRỰC TIẾP trong safeStandPos + tween + tele
-- (bump Y lên mặt nước + 2 khi điểm đến dưới nước). KHÔNG cần heartbeat riêng
-- → FloatForce (dập velocity → không rơi) + bump trong tween/tele là ĐỦ.
-- (Bản cũ có NoWater heartbeat 4 studs → xung đột + bump quá cao → bay lung tung.)

-- Chọn mục tiêu sau khi cache được cập nhật. Không dùng fallback toàn map:
-- mục tiêu phải có marker rõ ràng hoặc nằm trong bounds của PumpkinPatch.
-- v5.0: check quái có bị "Ignore" không (Jack o' Lantern / Pumpkin Snowman)
local function isIgnoredEnemy(model)
        if not isWorkspaceEnemy(model) then return false end
        local ln = model.Name:lower()
        if State.IgnoreJackOLantern and (ln:find("jack") or ln:find("lantern")) then
                return true
        end
        if State.IgnorePumpkinSnowman and (ln:find("snowman") or ln:find("snow")) then
                return true
        end
        return false
end

-- v5.0: check bí ngô hiếm (Rare Pumpkin) cho BreakRareOnly
local function isRarePumpkin(model)
        local ln = model.Name:lower()
        local rare = ln:find("rare") ~= nil
        pcall(function()
                rare = rare or model:GetAttribute("Rare") == true
                        or model:GetAttribute("Rarity") == "Rare"
                        or CollectionService:HasTag(model, "RarePumpkin")
        end)
        return rare
end

local function farmTargetAllowed(model)
        local lowerName = (model and model.Name or ""):lower()
        if State.FarmOnlyPumpkins then
                if isWorkspaceEnemy(model)
                        or lowerName:find("jack", 1, true)
                        or lowerName:find("lantern", 1, true)
                        or lowerName:find("snowman", 1, true)
                        or lowerName:find("snow man", 1, true) then
                        return false
                end
        end
        if isIgnoredEnemy(model) then return false end
        if State.BreakRareOnly and not isWorkspaceEnemy(model) and not isRarePumpkin(model) then
                return false
        end
        return true
end

local function pickNearest(rootPos, farmOrigin)
        local pumpkins = refreshPumpkins()
        local patches = MZ_World.patches
        local best, bestD = nil, math.huge
        for _, m in ipairs(pumpkins) do
                if pumpkinValid(m, rootPos) then
                        local r = modelRoot(m)
                        if r then
                                local d = (r.Position - rootPos).Magnitude
                                if withinFarmRadius(r.Position, farmOrigin)
                                        and isEventPumpkinTarget(m, r, patches) then
                                        local ok = farmTargetAllowed(m)
                                        if ok and isWorkspaceEnemy(m) and State.EnemyPriority then
                                                -- Ưu tiên quái khi không chạy chế độ chỉ farm nguyên liệu Pumpkin.
                                                d = d * 0.25
                                        end
                                        if ok and d < bestD then
                                                best, bestD = m, d
                                        end
                                end
                        end
                end
        end
        return best, bestD
end

local FarmGen = 0 -- mỗi lần bật tăng gen → vòng cũ tự thoát, KHÔNG bao giờ "chết im"

-- Đập 1 bí ngô tới khi chết. true = xong (chết/biến mất), false = bỏ quả này.
-- CÓ đo tiến triển: 12 hit không thấy máu giảm/part mất → tự đổi cách đánh → bỏ.
local function smashUntilDead(target, myGen, farmOrigin)
        local startClock = os.clock()
        local hits = 0
        local noProgress = 0
        local lastSnap = pumpkinSnapshot(target)
        local hasHum = (target:FindFirstChildOfClass("Humanoid") ~= nil)

        -- FIX "tele khùng khùng": giới hạn số lần và tần suất bay lại sát bí ngô.
        -- Trước đây không có cooldown → tween fail → distNow vẫn > ngưỡng → tween
        -- ngay → loop liên tục CFrame set → nhìn như tele loạn.
        local reapproachAttempts = 0     -- số lần đã bay lại sát bí ngô
        local MAX_REAPPROACH = 3         -- tối đa 3 lần; quá → blacklist bí ngô này
        local lastReapproachClock = 0    -- cooldown tối thiểu 1.5s giữa các lần

        while State.FarmPumpkin and (not myGen or myGen == FarmGen) do
                moveTouch("farm") -- gia hạn quyền di chuyển (đang giữ bus)
                local char = getChar()
                local root = getRoot()
                if not (char and root) then return false end
                if not target or target.Parent == nil then return true end
                local hum = target:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then return true end
                local rp = modelRoot(target)
                if not rp then return true end
                if not withinFarmRadius(rp.Position, farmOrigin)
                        or not isEventPumpkinTarget(target, rp, MZ_World.patches)
                        or not farmTargetAllowed(target) then
                        blacklist[target] = os.clock() + 30
                        return false
                end
                local distNow = (rp.Position - root.Position).Magnitude
                if distNow > 10 then
                        -- Bị văng / bí ngô dịch xa → thử bay lại (có giới hạn)
                        if reapproachAttempts >= MAX_REAPPROACH then
                                -- Đã thử đủ lần mà vẫn không giữ được vị trí
                                -- → khả năng terrain chặn / bí ngô không có collision thật
                                -- → blacklist ngắn rồi chọn quả khác, dừng "tele lòng vòng".
                                blacklist[target] = os.clock() + 30
                                State.StatusText = "Không giữ được vị trí bí ngô → đổi quả..."
                                return false
                        end
                        local now = os.clock()
                        if now - lastReapproachClock < 1.5 then
                                -- Cooldown chưa hết → đứng im đánh một nhịp rồi thử lại
                                task.wait(math.max(State.HitDelay, 0.3))
                        else
                                reapproachAttempts = reapproachAttempts + 1
                                lastReapproachClock = now
                                local flat = Vector3.new(root.Position.X - rp.Position.X,
                                        0, root.Position.Z - rp.Position.Z)
                                if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                                State.StatusText = string.format(
                                        "Bị văng → bay lại (lần %d/%d)...", reapproachAttempts, MAX_REAPPROACH)
                                MZ_Tween.to(CFrame.new(safeStandPos(
                                        rp.Position + flat.Unit * State.StandDist)),
                                        State.TweenSpeed, 2, true, "farm")
                                if not State.FarmPumpkin or (myGen and myGen ~= FarmGen) then
                                        return false
                                end
                        end
                elseif distNow > State.HitRange + 10 then
                        return false
                else
                        reapproachAttempts = 0 -- đang trong tầm → reset counter
                end
                if os.clock() - startClock > 35 then
                        -- quá lâu không chết → khả năng là pumpkin giả → ban 120s
                        blacklist[target] = os.clock() + 120
                        return false
                end

                equipFightingStyle()
                faceTarget(rp.Position)
                local hitType = doHit(target, rp.Position, root.Position)
                hits = hits + 1

                -- Hit delay: quái (fast attack) → RẤT NHANH (0.05-0.08s, BCH style).
                --              pumpkin M1 → nhịp người thật 0.30-0.42s.
                if isWorkspaceEnemy(target) then
                        task.wait(math.max(State.HitDelay, 0.05) + math.random() * 0.03)
                else
                        task.wait(hitType == "remote"
                                and math.max(State.HitDelay, 0.06)
                                or (math.max(State.HitDelay, 0.30) + math.random() * 0.12))
                end

                -- mỗi 4 hit kiểm tra 1 lần xem có ăn máu không
                if hits % 4 == 0 then
                        if not target.Parent then return true end
                        State.StatusText = string.format("Đang đập bí ngô (hit %d, %s)...",
                                hits, AtkMethod == "m1" and "M1 ảo" or "remote")
                        local snap = pumpkinSnapshot(target)
                        if snapshotChanged(snap, lastSnap) then
                                noProgress = 0
                        else
                                noProgress = noProgress + 4
                        end
                        lastSnap = snap

                        local budget = hasHum and 12
                                or (AtkMethod == "remote" and 48 or 24)
                        if noProgress >= budget then
                                if AtkMethod == "remote" then
                                        AtkMethod = "m1" -- remote không ăn → đổi sang M1 ảo
                                        noProgress = 0
                                        State.StatusText = "Remote không ăn damage → chuyển sang M1 ảo..."
                                        notify("Fast Attack", "Remote không gây damage → tự chuyển sang M1 ảo.", "warning")
                                else
                                        -- đập hoài không mất máu → PUMPKIN GIẢ / trang trí → ban 120s
                                        blacklist[target] = os.clock() + 120
                                        return false
                                end
                        end
                end
        end
        return false
end

-- Vòng farm chính — MỌI lỗi nhỏ đều pcall nên KHÔNG BAO GIỜ chết âm thầm
local function farmLoop()
        FarmGen = FarmGen + 1
        local myGen = FarmGen
        local noneCount = 0
        local originChar, farmOrigin = nil, nil
        while State.FarmPumpkin and myGen == FarmGen and not Unloaded do
                local ok, err = pcall(function()
                        local char, root, hum = getChar(), getRoot(), getHum()
                        if not (char and root and hum) or hum.Health <= 0 then
                                State.StatusText = "Chờ hồi sinh..."
                                MZ_Tween.cancel("farm")
                                task.wait(1)
                                return
                        end

                        if char ~= originChar then
                                originChar = char
                                farmOrigin = root.Position
                        end

                        if State.FarmMode == "Tới gần từng bí ngô" then
                                -- Đánh GẦN trước (pickNearest luôn chọn quả gần nhất);
                                -- hết quả gần → tự bay ra vùng XA, KHÔNG đứng im đợi
                                local target, dist = pickNearest(root.Position, farmOrigin)
                                if not target then
                                        noneCount = noneCount + 1
                                        State.StatusText = "Không thấy mục tiêu event trong bán kính farm..."
                                        refreshPumpkins(true)
                                        local now = os.clock()
                                        for m, t in pairs(blacklist) do
                                                if (t - now) < 8 or m.Parent == nil then
                                                        blacklist[m] = nil
                                                end
                                        end
                                        -- FIX "farm kẹt khi bay xa": sau 3 lần liên tiếp không tìm được
                                        -- mục tiêu, reset farmOrigin = vị trí hiện tại để mở lại vùng farm
                                        -- quanh chỗ player đang đứng (thay vì cứ bó buộc vào điểm bật ban đầu).
                                        if noneCount >= 3 then
                                                local curRoot = getRoot()
                                                if curRoot then
                                                        farmOrigin = curRoot.Position
                                                        _patchHasAnyCache = nil -- invalidate patch cache
                                                end
                                                noneCount = 0
                                                State.StatusText = "Mở rộng vùng farm từ vị trí hiện tại..."
                                        end
                                        task.wait(0.6)
                                        return
                                end
                                noneCount = 0
                                local rp = modelRoot(target)
                                if not rp then return end
                                -- v5.1: GIỮ QUYỀN DI CHUYỂN trong lúc xử lý 1 bí ngô
                                -- (doorLoop/bossLoop đang chạy sẽ chờ tới khi xong quả này)
                                if not moveAcquire("farm", 12) then return end
                                -- DISPATCH: QUÁI → bay CAO trên đầu (BCH style); PUMPKIN → đứng kế ben
                                local isEnemy = isWorkspaceEnemy(target)
                                local goalPos
                                if isEnemy then
                                        -- QUÁI: bay cao trên đầu (EnemyStandY studs lên, lệch EnemyStandDist XZ)
                                        local offsetDir = (root.Position - rp.Position)
                                        local flat = Vector3.new(offsetDir.X, 0, offsetDir.Z)
                                        if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                                        local enemyStand = (State.EnemyStandDist or 15) + math.random() * 2
                                        goalPos = safeStandPosEnemy(rp.Position + flat.Unit * enemyStand)
                                        State.StatusText = string.format("Bay trên đầu quái (%.0fm)", dist)
                                else
                                        -- PUMPKIN: đứng kế ben (StandDist studs, ngang tầm)
                                        local offsetDir = (root.Position - rp.Position)
                                        local standDist = State.StandDist + math.random() * 0.5
                                        if offsetDir.Magnitude < 0.1 then
                                                -- đang đứng đè lên bí ngô → lùi nhẹ ra rồi đập luôn
                                                pcall(function()
                                                        getRoot().CFrame = CFrame.new(safeStandPos(
                                                                rp.Position + Vector3.new(standDist, 0, 0)))
                                                end)
                                                goalPos = nil -- đã set CFrame trực tiếp
                                        else
                                                local flat = Vector3.new(offsetDir.X, 0, offsetDir.Z)
                                                if flat.Magnitude < 0.1 then
                                                        flat = Vector3.new(1, 0, 0)
                                                end
                                                goalPos = safeStandPos(rp.Position + flat.Unit * standDist)
                                                State.StatusText = string.format("Đang bay tới bí ngô (%.0fm)", dist)
                                        end
                                end
                                local reached = true
                                if goalPos then
                                        equipFightingStyle()
                                        if State.FarmTeleMode then
                                                reached = MZ_Teleport(CFrame.new(goalPos), "farm")
                                        else
                                                reached = MZ_Tween.to(CFrame.new(goalPos), State.TweenSpeed,
                                                        isEnemy and 5 or 2, true, "farm")
                                        end
                                end
                                if not State.FarmPumpkin then return end
                                if reached then
                                        -- KIỂM TRA đến nơi an toàn: target vẫn còn & ĐANG GẦN
                                        -- thì mới đập. (FIX "lâu lâu tự tele chỗ không có bí ngô":
                                        -- tween báo xong nhưng target bị game xóa/dịch → KHÔNG
                                        -- đứng đập khoảng trống, blacklist + chọn quả khác ngay.)
                                        local rpChk = modelRoot(target)
                                        local rootChk = getRoot()
                                        if not rpChk or not rootChk or target.Parent == nil then
                                                blacklist[target] = os.clock() + 8
                                                State.StatusText = "Bí ngô biến mất → chọn quả khác..."
                                        else
                                                local dChk = (rpChk.Position - rootChk.Position).Magnitude
                                                if dChk > (State.HitRange or 30) + 12 then
                                                        -- tween báo "reached" nhưng thực ra bị game kéo
                                                        -- về / kẹt → đang đứng sai chỗ → bỏ quả này
                                                        blacklist[target] = os.clock() + 20
                                                        State.StatusText = string.format(
                                                                "Không tới được bí ngô (%.0fm) → đổi quả", dChk)
                                                else
                                                        State.StatusText = "Đang đập bí ngô..."
                                                        smashUntilDead(target, myGen, farmOrigin)
                                                end
                                        end
                                else
                                        -- không tới được (kẹt / game kéo về) → tạm bỏ quả này
                                        local rp2 = modelRoot(target)
                                        local r2 = getRoot()
                                        if rp2 and r2
                                                and (rp2.Position - r2.Position).Magnitude > State.HitRange + 10 then
                                                blacklist[target] = os.clock() + 30
                                                State.StatusText = "Bỏ qua bí ngô khó tới..."
                                        end
                                end
                                task.wait(0.1)
                        else -- "Đập trong tầm (tự đuổi khi trống)"
                                refreshPumpkins()
                                local rootPos = root.Position
                                local patches = MZ_World.patches
                                local found = 0
                                local combatLease = false
                                for _, m in ipairs(MZ_World.pumpkins) do
                                        if not State.FarmPumpkin then break end
                                        if pumpkinValid(m, rootPos) and farmTargetAllowed(m) then
                                                local rp = modelRoot(m)
                                                if rp and withinFarmRadius(rp.Position, farmOrigin)
                                                        and isEventPumpkinTarget(m, rp, patches)
                                                        and (rp.Position - rootPos).Magnitude <= State.HitRange then
                                                        if not combatLease then
                                                                combatLease = moveAcquire("farm", 8)
                                                                if not combatLease then break end
                                                        end
                                                        found = found + 1
                                                        equipFightingStyle()
                                                        faceTarget(rp.Position)
                                                        doHit(m, rp.Position, rootPos)
                                                        task.wait(AtkMethod == "m1"
                                                                and (math.max(State.HitDelay, 0.30) + math.random() * 0.12)
                                                                or math.max(State.HitDelay, 0.06))
                                                end
                                        end
                                end
                                if combatLease then moveRelease("farm") end
                                State.StatusText = found > 0
                                        and string.format("Đang đập trong tầm (%d bí ngô, %s)",
                                                found, AtkMethod == "m1" and "M1 ảo" or "remote")
                                        or "Không có bí ngô trong tầm..."
                                -- KHÔNG đứng im đợi: hết bí ngô trong tầm → tự bay tới
                                -- quả GẦN NHẤT trong vùng giới hạn rồi đập tiếp
                                if found == 0 and State.FarmPumpkin then
                                        local target, dist = pickNearest(rootPos, farmOrigin)
                                        local rp = target and modelRoot(target)
                                        if rp then
                                                -- v5.1: chỉ tween đuổi khi không loop nào khác giữ quyền
                                                if not moveAcquire("farm", 8) then return end
                                                local away = (rootPos - rp.Position)
                                                local flat = Vector3.new(away.X, 0, away.Z)
                                                if flat.Magnitude < 0.1 then flat = Vector3.new(1, 0, 0) end
                                                State.StatusText = string.format(
                                                        "Trong tầm không có → bay tới (%.0fm)", dist or 0)
                                                equipFightingStyle()
                                                MZ_Tween.to(CFrame.new(safeStandPos(
                                                        rp.Position + flat.Unit * State.StandDist)),
                                                        State.TweenSpeed, 2, true, "farm")
                                        else
                                                -- map trống thật sự → dò lại + thả ban sắp hết hạn
                                                refreshPumpkins(true)
                                                local now = os.clock()
                                                for m2, t2 in pairs(blacklist) do
                                                        if (t2 - now) < 8 or m2.Parent == nil then
                                                                blacklist[m2] = nil
                                                        end
                                                end
                                                task.wait(0.6)
                                        end
                                end
                        end
                end)
                moveRelease("farm") -- v5.1: nhả quyền di chuyển sau mỗi bí ngô
                if not ok then
                        warn("[MZ Halloween] farmLoop lỗi (tự tiếp tục): " .. tostring(err))
                        State.StatusText = "Lỗi nhỏ — tự tiếp tục..."
                        task.wait(0.5)
                end
        end
        if myGen == FarmGen then
                State.StatusText = "Tắt"
        end
end

-- ════════════════════════════ 12. NHẶT ĐỒ RƠI ═════════════════════════════
-- Đọc từ MZ_World.drops (cache chung) — KHÔNG quét GetDescendants nữa (giảm lag)
local PickupGen = 0
local function pickupLoop()
        PickupGen = PickupGen + 1
        local myGen = PickupGen
        while State.PickupDrops and myGen == PickupGen and not Unloaded do
                local ok = pcall(function()
                        local root = getRoot()
                        local myChar = LocalPlayer.Character
                        if root and myChar then
                                refreshPumpkins() -- chỉ làm mới cache nếu đã quá 1.2s
                                for _, p in ipairs(MZ_World.drops) do
                                        if not State.PickupDrops then break end
                                        if p.Parent then
                                                local d = (p.Position - root.Position).Magnitude
                                                if d <= State.PickupRadius then
                                                        local fired = pcall(function()
                                                                firetouchinterest(root, p, 0)
                                                                firetouchinterest(root, p, 1)
                                                        end)
                                                        -- Không teleport để nhặt: tránh cướp quyền di chuyển của farm/door/boss.
                                                        -- Nếu executor không có firetouchinterest, bỏ qua vật phẩm này.
                                                        if not fired then
                                                                State.StatusText = "Pickup: executor thiếu firetouchinterest; không tự teleport nhặt đồ."
                                                        end
                                                        task.wait(0.12)
                                                end
                                        end
                                end
                        end
                end)
                if not ok then task.wait(1) end
                task.wait(0.35)
        end
end

-- ════════════════════════════ 13. PROXIMITY PROMPT (Cửa / Gacha) ══════════
local function firePrompt(prompt)
        local fired = false
        if type(fireproximityprompt) == "function" then
                fired = pcall(fireproximityprompt, prompt)
        end
        if not fired then
                pcall(function()
                        prompt:InputHoldBegin()
                        task.wait((prompt.HoldDuration or 0) + 0.15)
                        prompt:InputHoldEnd()
                end)
        end
end

local function promptPart(prompt)
        local holder = prompt.Parent
        if not holder then return nil end
        if holder:IsA("BasePart") then return holder end
        return holder:FindFirstChildWhichIsA("BasePart", true)
end

-- (v5.1: ĐÃ XÓA promptLoop + promptLastFired — dead code từ v5.0, không
--  còn được gọi. Gõ cửa = doorLoop (13b), gacha = gachaLoop (13c) — cả
--  hai đều dùng dialog engine + MoveBus, không còn logic trùng lặp này.)

-- ════════════════════════════ 13b. AUTO GÕ CỬA (REWRITE v5.1) ═══════════════
-- Rewrite TOÀN BỘ theo feedback + kỹ thuật BCH:
--   1. Tìm cửa (ProximityPrompt + ClickDetector).
--   2. Bay tới cửa (chống chạm nước — FloatForce + bump nước).
--   3. Fire E prompt.
--   4. ↕ XỬ LÝ DIALOGUE (bản cũ THIẾU — lỗi "bấm E xong không bấm tiếp tục"):
--      sau khi bấm E, hộp thoại NPC hiện ("Trick or Treat!" / thoại Zer0...)
--      → cần CLICK TIẾP TỤC. Kỹ thuật BCH: VirtualUser:Button1Down x2 khi
--      PlayerGui.Main.Dialogue.Visible + fire TextButton qua getconnections.
--   5. ↕ MOB SPAWN: gõ cửa spawn quái → BAY TRÊN ĐẦU quái (BCH style) +
--      fast attack AOE tới khi chết → rồi mới sang cửa khác.
--   6. LOCKED → khóa 180s → đổi cửa khác NGAY.
local doorCooldown = {}  -- [inst] = expiry (ngắn 30s — đã gõ, không spam lại prompt này)
local houseState = {}    -- [CĂN NHÀ (Model)] = { lockUntil, nextVisit, fails } — v5.1: khóa theo NHÀ, không theo prompt

local candyReliable = false
local CANDY_VALUE_NAMES = {
        candy = true,
        candycorn = true,
        candycorncount = true,
        candycount = true,
        halloweencandy = true,
        halloweencandycount = true,
        treat = true,
        treats = true,
        treatcount = true,
}

local function candyNow()
        candyReliable = false
        local pl = LocalPlayer
        local sourceNames = { "Data", "PlayerData", "Stats", "leaderstats" }
        for _, folderName in ipairs(sourceNames) do
                local folder = pl:FindFirstChild(folderName)
                if folder then
                        for _, valueObj in ipairs(folder:GetDescendants()) do
                                if valueObj:IsA("IntValue") or valueObj:IsA("NumberValue")
                                        or valueObj:IsA("IntConstrainedValue") then
                                        local normalized = (valueObj.Name or ""):lower():gsub("[^%w]", "")
                                        if CANDY_VALUE_NAMES[normalized] then
                                                candyReliable = true
                                                return tonumber(valueObj.Value) or 0
                                        end
                                end
                        end
                end
        end
        return 0
end
-- ghép text của prompt/clicker + 5 tổ tiên để match keyword cửa
local function doorText(inst)
        local parts = {}
        local cur = inst
        for _ = 1, 5 do
                if not cur then break end
                table.insert(parts, cur.Name or "")
                cur = cur.Parent
        end
        if inst:IsA("ProximityPrompt") then
                table.insert(parts, inst.ActionText or "")
                table.insert(parts, inst.ObjectText or "")
        end
        return table.concat(parts, " "):lower()
end

local function doorPart(inst)
        if inst:IsA("ClickDetector") then
                local h = inst.Parent
                if h and h:IsA("BasePart") then return h end
                return h and h:FindFirstChildWhichIsA("BasePart", true)
        end
        return promptPart(inst)
end

local function fireDoor(inst)
        if inst:IsA("ClickDetector") then
                if type(fireclickdetector) == "function" then
                        return pcall(fireclickdetector, inst)
                end
                return false
        end
        -- ProximityPrompt: thử fireproximityprompt trước, rồi thử :InputHoldBegin/End
        -- (một số prompt "Trick or Treat" cần E hold mới ăn)
        local fired = false
        if type(fireproximityprompt) == "function" then
                fired = pcall(fireproximityprompt, inst)
        end
        if not fired then
                fired = pcall(function()
                        inst:InputHoldBegin()
                        task.wait((inst.HoldDuration or 0) + 0.2)
                        inst:InputHoldEnd()
                end)
        end
        return fired
end

-- ═══ v5.1: DIALOG ENGINE — STATE MACHINE XỬ LÝ THOẠI (rewrite toàn bộ) ═══
-- Fix "bấm E xong KHÔNG bấm Tiếp tục" triệt để:
--   • Snapshot các nút đang hiện TRƯỚC khi gõ cửa → chỉ bấm nút MỚI xuất hiện
--     (không bấm nhầm UI khác / nút của Hub / nút đã có sẵn).
--   • Tìm TextButton/ImageButton theo text "Tiếp tục/Continue/Next/OK..."
--     (kèm biến thể tiếng Việt có dấu + không dấu, hoa/thường + text lồng
--     trong TextLabel con của nút).
--   • Bấm bằng 4 LỚP: getconnections(Activated/MouseButton1Click):Fire()
--     → firesignal → VIM click THẬT tại tâm nút → VirtualUser (BCH pattern).
--   • Thu thập TEXT thoại → phân tích LOCKED ("khóa/not home/trở lại sau...")
--     → nhận diện nhà locked NGAY CẢ KHI không đọc được Candy.
local DLG_POSITIVE = {
        "Tiếp tục", "tiếp tục", "Tiep tuc", "tiep tuc", "Tiếp tuc", "tiếp tục",
        "Continue", "continue", "CONTINUE",
        "Next", "next", "NEXT",
        "OK", "Ok", "Đồng ý", "đồng ý", "Xác nhận", "xác nhận", "Chấp nhận",
        "Có", "Yes", "yes",
        "Claim", "claim", "Nhận", "Collect", "Receive", "Got it",
        "Trick or Treat", "Knock",
}
local DLG_CONTINUE = {
        "continue", "tiếp tục", "tiep tuc", "next", "next page", "ok", "got it",
        "xác nhận", "xac nhan", "đồng ý", "dong y", "understood",
}
local DLG_NEGATIVE = {
        "Cancel", "cancel", "Hủy", "hủy", "Huỷ", "Từ chối", "từ chối",
        "Decline", "decline", "Exit", "exit", "Thoát", "thoát", "Close game",
        "Không", "không", "No thanks",
}
local LOCK_TEXT = {
        "locked", "Locked", "LOCKED", "khóa", "Khoá", "đã khóa",
        "not home", "không có nhà", "vắng nhà", "vắng chủ",
        "come back later", "trở lại sau", "quay lại sau",
        "already", "đã ghé", "đã gõ", "đã hết",
}

local function textHasAny(text, list)
        if not text or text == "" then return false end
        for _, p in ipairs(list) do
                if text:find(p, 1, true) then return true end
        end
        return false
end

local function isPositiveBtn(text)
        return textHasAny(text, DLG_POSITIVE)
                or textHasAny((text or ""):lower(), DLG_POSITIVE)
end

local function isNegativeBtn(text)
        return textHasAny(text, DLG_NEGATIVE)
                or textHasAny((text or ""):lower(), DLG_NEGATIVE)
end

local function isContinueBtn(text)
        return textHasAny((text or ""):lower(), DLG_CONTINUE)
end

-- GUI bị loại khỏi quét (Hub của mình + GUI lõi của Roblox)
local function isExcludedGui(sg)
        local n = (sg.Name or ""):lower()
        if n:find("meizu", 1, true) then return true end
        for _, ex in ipairs({ "chat", "playerlist", "leaderboard", "backpack",
                        "touchgui", "bubblechat", "notification", "emotesmenu", "inventory" }) do
                if n:find(ex, 1, true) then return true end
        end
        return false
end

-- nút chỉ hợp lệ khi CHUỖI ancestor đều hiện (Visible/Enabled)
local function guiVisibleChain(obj)
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local node = obj
        while node and node ~= pg do
                if node:IsA("GuiObject") and not node.Visible then return false end
                if node:IsA("ScreenGui") and not node.Enabled then return false end
                node = node.Parent
        end
        return true
end

-- text của nút = Name + Text + TextLabel con (nhiều nút bọc label bên trong)
local function btnTextOf(btn)
        local parts = { btn.Name or "" }
        if btn:IsA("TextButton") then
                table.insert(parts, btn.Text or "")
        end
        for _, ch in ipairs(btn:GetDescendants()) do
                if ch:IsA("TextLabel") or ch:IsA("TextBox") then
                        table.insert(parts, ch.Text or "")
                end
        end
        return table.concat(parts, " ")
end

local function findGuiButtonWithPhrase(phrase, rootGui)
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local roots = rootGui and { rootGui } or pg:GetChildren()
        for _, sg in ipairs(roots) do
                if sg and (not sg:IsA("ScreenGui") or sg.Enabled) then
                        local ok, descendants = pcall(function() return sg:GetDescendants() end)
                        if ok then
                                for _, d in ipairs(descendants) do
                                        if (d:IsA("TextButton") or d:IsA("ImageButton"))
                                                and guiVisibleChain(d) then
                                                local textValue = btnTextOf(d):lower()
                                                if textValue:find(phrase:lower(), 1, true) then
                                                        return d
                                                end
                                        end
                                end
                        end
                end
        end
        return nil
end

local function findAncestorNamed(instance, wantedName)
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local node = instance
        while node and node ~= playerGui do
                if node.Name == wantedName then return node end
                node = node.Parent
        end
        return nil
end

-- Chữ hiển thị của một trang hội thoại. Dùng signature để không click lặp
-- cùng một trang nếu game giữ nguyên TextButton giữa nhiều bước.
local function dialogueSignature(frame)
        if not frame then return "" end
        local parts = { frame.Name or "Dialogue" }
        pcall(function()
                for _, item in ipairs(frame:GetDescendants()) do
                        if guiVisibleChain(item) then
                                if item:IsA("TextLabel") or item:IsA("TextButton") then
                                        local value = (item.Text or ""):gsub("%s+", " ")
                                        if value ~= "" then table.insert(parts, value) end
                                elseif item:IsA("ImageButton") then
                                        local value = item.Name or ""
                                        if value ~= "" then table.insert(parts, value) end
                                end
                        end
                end
        end)
        return table.concat(parts, "|")
end

-- Snapshot chữ của các trang Continue đang hiện trước khi gõ.
-- Nếu game tái sử dụng cùng button nhưng nội dung trang thay đổi, signature mới
-- vẫn được phép xử lý; nếu UI cũ giữ nguyên, không bấm nhầm lại.
local function snapshotPositiveButtons()
        local set = {}
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return set end
        for _, sg in ipairs(pg:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Enabled and not isExcludedGui(sg) then
                        for _, d in ipairs(sg:GetDescendants()) do
                                if (d:IsA("TextButton") or d:IsA("ImageButton"))
                                                and guiVisibleChain(d) and isContinueBtn(btnTextOf(d)) then
                                        local frame = findAncestorNamed(d, "Dialogue")
                                                or findAncestorNamed(d, "Dialog")
                                        if frame then set[d] = dialogueSignature(frame) end
                                end
                        end
                end
        end
        return set
end

-- Tìm nút Continue/Next chỉ trong frame Dialogue/Dialog.
local function findDialogButton(preBtns)
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return nil end
        preBtns = preBtns or {}
        local best, bestScore = nil, math.huge
        for _, sg in ipairs(pg:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Enabled and not isExcludedGui(sg) then
                        for _, d in ipairs(sg:GetDescendants()) do
                                if (d:IsA("TextButton") or d:IsA("ImageButton"))
                                                and guiVisibleChain(d) then
                                        local txt = btnTextOf(d)
                                        if #txt < 120 and isContinueBtn(txt)
                                                        and not isNegativeBtn(txt) then
                                                local frame = findAncestorNamed(d, "Dialogue")
                                                        or findAncestorNamed(d, "Dialog")
                                                if frame then
                                                        local signature = dialogueSignature(frame)
                                                        local oldSignature = preBtns[d]
                                                        if oldSignature == nil or oldSignature ~= signature then
                                                                local score = d:IsA("TextButton") and 0 or 10
                                                                if score < bestScore then
                                                                        best, bestScore = d, score
                                                                end
                                                        end
                                                end
                                        end
                                end
                        end
                end
        end
        return best
end

-- BẤM nút GUI — 4 LỚP (thứ tự: chính xác → mạnh):
--   (1) getconnections(Activated + MouseButton1Click):Fire() — chính xác nhất
--   (2) firesignal (executor nào có)
--   (3) VIM click THẬT tại tâm nút — ăn MỌI handler (kể cả InputBegan)
--   (4) VirtualUser Button1Down (pattern BCH Main.Dialogue)
local function clickGuiButton(btn)
        -- (1) connections
        local fired = false
        if getconnections then
                for _, sig in ipairs({ btn.Activated, btn.MouseButton1Click }) do
                        pcall(function()
                                for _, c in ipairs(getconnections(sig)) do
                                        local okFire = pcall(function() c:Fire() end)
                                        if okFire then fired = true end
                                end
                        end)
                end
        end
        if fired then return true end
        -- (2) firesignal
        if type(firesignal) == "function" then
                local okSignal = pcall(function()
                        firesignal(btn.MouseButton1Click)
                        firesignal(btn.Activated)
                end)
                if okSignal then return true end
        end
        -- (3) VIM click thật tại tâm nút
        local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
        if size and size.X > 0 and size.Y > 0 then
                local x = pos.X + size.X / 2
                local y = pos.Y + size.Y / 2
                local okClick = pcall(function()
                        VIM:SendMouseMoveEvent(x, y, game)
                        task.wait(0.03)
                        VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                        task.wait(0.05 + math.random() * 0.04)
                        VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
                end)
                return okClick
        end
        -- (4) VirtualUser (BCH pattern)
        local okVirtual = pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new(0, 0))
        end)
        return okVirtual
end

-- BCH pattern: hộp thoại Main.Dialogue của BF (click chuột là tiến thoại)
local function bchDialogueFrame()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local main = pg:FindFirstChild("Main")
        local dlg = main and main:FindFirstChild("Dialogue")
        if dlg and dlg:IsA("GuiObject") and dlg.Visible then return dlg end
        for _, name in ipairs({ "Dialogue", "Dialog", "DialogueFrame" }) do
                local d = pg:FindFirstChild(name)
                if d then
                        if d:IsA("ScreenGui") and d.Enabled then return d end
                        if d:IsA("GuiObject") and d.Visible then return d end
                end
        end
        return nil
end

local function bchDialogueClick()
        pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.04)
                VirtualUser:Button1Up(Vector2.new(0, 0))
        end)
end

local function isChoiceOrMinigameDialogue(frame)
        if not frame then return false end
        local textParts = {}
        pcall(function()
                for _, item in ipairs(frame:GetDescendants()) do
                        if item:IsA("TextLabel") or item:IsA("TextButton") then
                                table.insert(textParts, (item.Text or ""):lower())
                        elseif item:IsA("ImageButton") then
                                table.insert(textParts, (item.Name or ""):lower())
                        end
                end
        end)
        local body = table.concat(textParts, " ")
        for _, token in ipairs({
                "tarot", "celestial", "oni", "which room", "what room",
                "choose a card", "pick a card", "match the cards", "memory game",
                "choose one", "select one", "make a choice", "choose", "choice", "option",
                "free roll", "one free roll", "celestial", "oni", "witch tarot",
                "i want to fight the great pumpkin", "lựa chọn", "chọn phòng",
                "chọn lá bài", "ghép bài"
        }) do
                if body:find(token, 1, true) then return true end
        end
        return false
end

-- Thu thập TEXT thoại quanh nút (3 tầng trên nút = frame thoại)
-- → dùng để phân tích locked / reward khi verify kết quả gõ cửa
local DialogueLog = {}
local function collectDialogTextFrom(btn)
        pcall(function()
                local node = btn
                for _ = 1, 3 do
                        if node.Parent then node = node.Parent end
                end
                for _, d in ipairs(node:GetDescendants()) do
                        if d:IsA("TextLabel") and guiVisibleChain(d) then
                                local t = d.Text or ""
                                if #t >= 4 and #t <= 400 then
                                        local known = false
                                        for _, old in ipairs(DialogueLog) do
                                                if old == t then known = true break end
                                        end
                                        if not known and #DialogueLog < 40 then
                                                table.insert(DialogueLog, t)
                                        end
                                end
                        end
                end
        end)
end

-- text thoại gợi ý nhà LOCKED?
local function textSuggestsLocked(t)
        return textHasAny(t, LOCK_TEXT)
end

-- v5.1: bấm qua TOÀN BỘ thoại ĐANG HIỆN (dùng cho gacha/summon/hall).
-- ⚠ KHÔNG dùng snapshot-loại-nút-cũ như doorLoop — vì hàm này được gọi
-- SAU khi dialog đã mở (bấm prompt xong chờ 1s mới gọi) → nếu snapshot lúc
-- đó thì nút Continue bị coi là "đã có sẵn" và KHÔNG BAO GIỜ được bấm.
-- Nên quét thẳng mọi nút positive đang hiện (đã lọc GUI bị exclude).
local function clickThroughAnyDialogue()
        local n = 0
        local seenPages = {}
        local btn = findDialogButton({})
        while btn and n < 6 do
                local dlgFrame = findAncestorNamed(btn, "Dialogue")
                        or findAncestorNamed(btn, "Dialog")
                if dlgFrame and isChoiceOrMinigameDialogue(dlgFrame) then break end
                local signature = dialogueSignature(dlgFrame or btn)
                if seenPages[signature] then break end
                if not clickGuiButton(btn) then break end
                seenPages[signature] = true
                n = n + 1
                task.wait(0.35 + math.random() * 0.25)
                btn = findDialogButton({})
        end
        local frame = bchDialogueFrame()
        if n == 0 and frame and not isChoiceOrMinigameDialogue(frame) then
                local signature = dialogueSignature(frame)
                if not seenPages[signature] then
                        bchDialogueClick()
                        n = 1
                end
        end
        return n
end

-- ═══ v5.1: THEO DÕI QUÁI SPAWN TỪ CỬA (chỉ đánh quái MỚI sinh ra do gõ cửa) ═══
-- Snapshot Enemies TRƯỚC khi gõ → sau đó chỉ đám MỚI xuất hiện gần cửa 90
-- studs được đưa vào danh sách đánh (hết đánh lan sang quái unrelated).
local function snapshotEnemies()
        local set = {}
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
                for _, e in ipairs(enemies:GetChildren()) do set[e] = true end
        end
        return set
end

-- liệt kê quái MỚI (không có trong snapshot) + còn sống + gần cửa
local function newEnemiesSince(set, centerPos, radius)
        local list = {}
        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return list end
        for _, e in ipairs(enemies:GetChildren()) do
                if not set[e] then
                        local hrp = e:FindFirstChild("HumanoidRootPart")
                        local hum = e:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.Health > 0
                                        and (not centerPos
                                                or (hrp.Position - centerPos).Magnitude <= (radius or 90)) then
                                table.insert(list, e)
                        end
                end
        end
        return list
end

-- ĐÁNH danh sách quái đang theo dõi (bay TRÊN ĐẦU + fast attack + M1 fallback)
-- tracked = SET [model] = true. Trả về số quái còn sống.
local CombatRemoteFails = 0
local function fightTrackedMobs(tracked)
        local root = getRoot()
        if not root then return 0 end
        local best, bestHRP, bestD = nil, nil, math.huge
        for e in pairs(tracked) do
                if e.Parent then
                        local hum = e:FindFirstChildOfClass("Humanoid")
                        local hrp = e:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 then
                                local d = (hrp.Position - root.Position).Magnitude
                                if d < bestD then best, bestHRP, bestD = e, hrp, d end
                        else
                                tracked[e] = nil -- chết / biến mất
                        end
                else
                        tracked[e] = nil
                end
        end
        if not best then return 0 end
        -- bay TRÊN ĐẦU quái gần nhất (BCH style) + chống chạm nước
        local flatAway = Vector3.new(root.Position.X - bestHRP.Position.X, 0,
                root.Position.Z - bestHRP.Position.Z)
        if flatAway.Magnitude < 0.1 then flatAway = Vector3.new(1, 0, 0) end
        local hoverPos = safeStandPosEnemy(bestHRP.Position + flatAway.Unit * (State.EnemyStandDist or 15))
        local wY = groundwaterY(hoverPos)
        if wY and hoverPos.Y < wY + 3 then
                hoverPos = Vector3.new(hoverPos.X, wY + 3, hoverPos.Z)
        end
        local reached = true
        if bestD > 10 then
                State.StatusText = "Bay trên đầu quái spawn... (" .. best.Name .. ")"
                if State.FarmTeleMode then
                        reached = MZ_Teleport(CFrame.new(hoverPos), "tot")
                else
                        reached = MZ_Tween.to(CFrame.new(hoverPos), State.TweenSpeed, 6, true, "tot")
                end
        end
        local rootAfterMove = getRoot()
        if not reached or not rootAfterMove
                or (rootAfterMove.Position - bestHRP.Position).Magnitude > (State.HitRange or 30) + 12 then
                local stillAlive = 0
                for e in pairs(tracked) do
                        local h = e.Parent and e:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 then stillAlive = stillAlive + 1 end
                end
                State.StatusText = "Chưa tới đủ gần quái spawn; tạm không gửi đòn đánh từ xa."
                return stillAlive
        end
        -- FAST ATTACK AOE (RegisterAttack + RegisterHit — BCH style)
        -- + M1 FALLBACK: remote bị chặn 3 lần liên tiếp → M1 người thật
        equipFightingStyle()
        faceTarget(bestHRP.Position)
        if hitEnemiesFastAttack(tracked) then
                CombatRemoteFails = 0
        else
                CombatRemoteFails = CombatRemoteFails + 1
                if CombatRemoteFails >= 3 then
                        hitPumpkinM1(bestHRP.Position)
                end
        end
        local alive = 0
        for e in pairs(tracked) do
                if e.Parent then
                        local hum = e:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then alive = alive + 1 end
                end
        end
        return alive
end

-- ═══ v5.1: LOCKED THEO CĂN NHÀ (không theo từng prompt) ═══
-- 1 nhà nhiều prompt → khóa 1 lần là SANG NHÀ KHÁC (không thử lại prompt
-- khác của cùng nhà đó).
local function houseKeyOf(inst)
        local node = inst.Parent
        local nearestModel = nil
        while node and node ~= workspace do
                if node:IsA("Model") then
                        local n = (node.Name or ""):lower()
                        if n:find("house", 1, true) or n:find("home", 1, true)
                                or n:find("residence", 1, true) or n:find("neighbor", 1, true) then
                                return node
                        end
                        if not nearestModel then nearestModel = node end
                end
                node = node.Parent
        end
        return nearestModel or inst
end

-- đọc trạng thái khóa THẬT từ attribute (Locked/IsLocked/Unlocked) của
-- prompt → door part → house model (đi lên tối đa 6 tầng ancestors)
local function doorLockedAttribute(inst)
        local node = inst
        for _ = 1, 6 do
                if not node or node == workspace then break end
                local ok, has = pcall(function()
                        return node:GetAttribute("Locked") ~= nil
                                or node:GetAttribute("IsLocked") ~= nil
                                or node:GetAttribute("Unlocked") ~= nil
                end)
                if ok and has then
                        local locked = node:GetAttribute("Locked")
                        if locked ~= nil then return locked == true end
                        local isLocked = node:GetAttribute("IsLocked")
                        if isLocked ~= nil then return isLocked == true end
                        local unlocked = node:GetAttribute("Unlocked")
                        if unlocked ~= nil then return unlocked ~= true end
                end
                node = node.Parent
        end
        return nil -- không có attribute → unknown
end

local isHarvestMoonWindow -- forward declaration: doorLoop captures this local up front
local DoorGen = 0
local function doorLoop()
        DoorGen = DoorGen + 1
        local myGen = DoorGen
        local noneNotified = false
        while State.TrickOrTreat and myGen == DoorGen and not Unloaded do
                local moonActive = isHarvestMoonWindow()
                if moonActive == false then
                        State.StatusText = "Đang chờ Harvest Moon (10 phút đầu mỗi giờ server)..."
                        task.wait(1.5)
                elseif moonActive == nil then
                        State.StatusText = "Không đọc được server clock; tạm dừng gõ cửa để tránh chạy sai giờ event."
                        task.wait(2)
                else
                local ok = pcall(function()
                        local root = getRoot()
                        if not root then task.wait(1) return end
                        refreshPumpkins()
                        local now = os.clock()
                        for k, t in pairs(doorCooldown) do
                                if now > t then doorCooldown[k] = nil end
                        end
                        for k, st in pairs(houseState) do
                                if (st.lockUntil or 0) < now and (st.nextVisit or 0) < now then
                                        houseState[k] = nil
                                end
                        end

                        local farmOn = State.FarmPumpkin
                        local maxD = farmOn
                                and math.min(State.KnockRadius, (State.HitRange or 30) + 40)
                                or State.KnockRadius

                        -- v5.1: cửa "sẵn sàng" = NHÀ chưa bị khóa / chưa vừa gõ
                        -- (khóa theo CĂN NHÀ — 1 nhà nhiều prompt chỉ tính 1 lần)
                        local function houseReady(inst)
                                local hs = houseState[houseKeyOf(inst)]
                                if not hs then return true end
                                local n2 = os.clock()
                                if (hs.lockUntil or 0) > n2 then return false end
                                if (hs.nextVisit or 0) > n2 then return false end
                                return true
                        end

                        -- quét ProximityPrompt
                        local best, bestD, bestPart, bestIsClick = nil, math.huge, nil, false
                        for _, pr in ipairs(MZ_World.prompts) do
                                if not State.TrickOrTreat then break end
                                if pr.Enabled and pr.Parent
                                        and not doorCooldown[pr]
                                        and matchKeyword(doorText(pr), State.KnockKeywords)
                                        and houseReady(pr) then
                                        local part = doorPart(pr)
                                        if part then
                                                local d = (part.Position - root.Position).Magnitude
                                                if d <= maxD and d < bestD then
                                                        best, bestD, bestPart, bestIsClick = pr, d, part, false
                                                end
                                        end
                                end
                        end
                        -- quét ClickDetector (nhiều game cửa dùng ClickDetector)
                        if State.TrickOrTreat and (not best or bestD > 8) then
                                for _, cd in ipairs(MZ_World.clickers or {}) do
                                        if not State.TrickOrTreat then break end
                                        if cd.Parent and not doorCooldown[cd]
                                                and matchKeyword(doorText(cd), State.KnockKeywords)
                                                and houseReady(cd) then
                                                local part = doorPart(cd)
                                                if part then
                                                        local d = (part.Position - root.Position).Magnitude
                                                        if d <= maxD and d < bestD then
                                                                best, bestD, bestPart, bestIsClick = cd, d, part, true
                                                        end
                                                end
                                        end
                                end
                        end

                        if not best then
                                if not noneNotified then
                                        noneNotified = true
                                        notify("Trick-or-Treat", farmOn
                                                and "Không có cửa trong tầm đánh — đứng gần nhà rồi bật."
                                                or "Không tìm thấy cửa nào — event gõ cửa thường chỉ mở ĐẦU GIỜ (XX:00). Di chuyển gần khu nhà rồi bật lại.", "info")
                                end
                                State.StatusText = farmOn and "Farm bật — không có cửa trong tầm" or "Không thấy cửa nào..."
                                task.wait(1.5)
                                return
                        end
                        noneNotified = false

                        -- v5.1 MOVE BUS: chờ farm xong bí ngô hiện tại rồi mới kéo
                        -- nhân vật đi (hết bị 2 loop giành nhau)
                        if not moveAcquire("tot", 60) then return end

                        -- bay tới cửa: dùng MaxActivationDistance của prompt (thường 5-10)
                        -- để đảm bảo ĐỦ GẦN để fire
                        local activationDist = 10
                        if not bestIsClick and best.MaxActivationDistance then
                                activationDist = math.min(activationDist, best.MaxActivationDistance - 1)
                        end
                        activationDist = math.max(activationDist, 3)
                        if bestD > activationDist then
                                local away = (root.Position - bestPart.Position)
                                if away.Magnitude > 0.1 then
                                        local goalPos = safeStandPos(bestPart.Position + away.Unit * activationDist)
                                        State.StatusText = string.format("Đang bay tới cửa (%.0fm)", bestD)
                                        local moved
                                        if State.FarmTeleMode then
                                                moved = MZ_Teleport(CFrame.new(goalPos), "tot")
                                        else
                                                moved = MZ_Tween.to(CFrame.new(goalPos),
                                                        State.TweenSpeed, 4, true, "tot")
                                        end
                                        local nearRoot = getRoot()
                                        if not moved or not nearRoot
                                                or (nearRoot.Position - bestPart.Position).Magnitude > activationDist + 4 then
                                                State.StatusText = "Không tới được cửa; bỏ qua thay vì gõ từ xa."
                                                moveRelease("tot")
                                                return
                                        end
                                        task.wait(0.3) -- chờ đứng ổn định
                                end
                        end
                        if not State.TrickOrTreat then return end

                        -- ═══ GÕ CỬA + STATE MACHINE THOẠI + ĐÁNH QUÁI SPAWN ═══
                        local houseKey = houseKeyOf(best)
                        local doorPos = bestPart.Position
                        -- snapshot TRƯỚC: quái đang có + nút thoại đang hiện
                        local beforeEnemies = snapshotEnemies()
                        local preBtns = snapshotPositiveButtons()
                        local clickedDialogSignatures = {}
                        DialogueLog = {}
                        local candyBefore = candyNow()

                        faceTarget(doorPos)
                        State.StatusText = "Đang gõ cửa... (chờ thoại + Candy)"
                        -- fire 1 lần — không spam; chỉ vào state machine khi pcall thật sự thành công.
                        local doorCallOk, doorFired = pcall(fireDoor, best)
                        if not doorCallOk or not doorFired then
                                doorCooldown[best] = os.clock() + 15
                                houseState[houseKey] = { fails = 1, nextVisit = os.clock() + 30 }
                                State.StatusText = "Executor/game không kích hoạt được cửa; tạm bỏ qua cửa này."
                                moveRelease("tot")
                                return
                        end
                        doorCooldown[best] = os.clock() + 30

                        -- VÒNG XỬ LÝ (max 40s): bấm thoại "Tiếp tục" + đánh quái
                        -- MỚI spawn từ cửa (không đánh quái unrelated).
                        local trackedMobs = {}
                        local clickedTotal = 0
                        local phaseStart = os.clock()
                        local lastMobClock = os.clock()
                        local lastDlgClock = os.clock()
                        while State.TrickOrTreat and myGen == DoorGen
                                        and os.clock() - phaseStart < 40 do
                                moveTouch("tot") -- gia hạn quyền trong lúc xử lý cửa
                                -- (1) nút thoại mới xuất hiện → bấm + thu text
                                local btn = findDialogButton(preBtns)
                                if btn then
                                        local dlgFrame = findAncestorNamed(btn, "Dialogue")
                                                or findAncestorNamed(btn, "Dialog")
                                        if dlgFrame and isChoiceOrMinigameDialogue(dlgFrame) then
                                                State.StatusText = "Đã phát hiện nội dung minigame/lựa chọn; không tự click Continue trong màn này."
                                                task.wait(0.25)
                                        else
                                                local signature = dialogueSignature(dlgFrame or btn)
                                                if not clickedDialogSignatures[signature] then
                                                        collectDialogTextFrom(btn)
                                                        if clickGuiButton(btn) then
                                                                clickedDialogSignatures[signature] = true
                                                                clickedTotal = clickedTotal + 1
                                                                lastDlgClock = os.clock()
                                                        end
                                                end
                                                task.wait(0.35 + math.random() * 0.3)
                                        end
                                elseif bchDialogueFrame() then
                                        local frame = bchDialogueFrame()
                                        local hasChoice = false
                                        if frame then
                                                for _, child in ipairs(frame:GetDescendants()) do
                                                        if (child:IsA("TextButton") or child:IsA("ImageButton"))
                                                                and guiVisibleChain(child) then
                                                                hasChoice = true
                                                                break
                                                        end
                                                end
                                        end
                                        local signature = dialogueSignature(frame)
                                        if not hasChoice and not isChoiceOrMinigameDialogue(frame)
                                                and not clickedDialogSignatures[signature] then
                                                bchDialogueClick()
                                                clickedDialogSignatures[signature] = true
                                                clickedTotal = clickedTotal + 1
                                                lastDlgClock = os.clock()
                                                task.wait(0.3)
                                        else
                                                State.StatusText = "Dialogue là lựa chọn/minigame; dừng auto-click để tránh chọn sai."
                                        end
                                elseif LocalPlayer:FindFirstChild("PlayerGui") then
                                        -- Gặp màn hình minigame/choice không phải Continue: dừng bấm tự động.
                                        State.StatusText = "Đang có lựa chọn/minigame event — giữ nguyên UI, không tự chọn đáp án."
                                end
                                -- (2) quái MỚI spawn từ cửa → theo dõi + đánh
                                if State.AutoAttackMobs then
                                        for _, e in ipairs(newEnemiesSince(beforeEnemies, doorPos, 90)) do
                                                trackedMobs[e] = true
                                        end
                                        if fightTrackedMobs(trackedMobs) > 0 then
                                                lastMobClock = os.clock()
                                        end
                                end
                                -- thoát sớm: tối thiểu 4s + 3s hết quái + 2.5s hết thoại
                                if os.clock() - phaseStart > 4
                                        and os.clock() - lastMobClock > 3
                                        and os.clock() - lastDlgClock > 2.5 then
                                        break
                                end
                                task.wait(0.2)
                        end
                        -- bấm nốt 2 nhịp thoại cuối (nếu trang tiếp theo vừa hiện)
                        for _ = 1, 2 do
                                if not State.TrickOrTreat or Unloaded then break end
                                local btn = findDialogButton(preBtns)
                                if not btn then break end
                                local dlgFrame = findAncestorNamed(btn, "Dialogue")
                                        or findAncestorNamed(btn, "Dialog")
                                if dlgFrame and isChoiceOrMinigameDialogue(dlgFrame) then break end
                                local signature = dialogueSignature(dlgFrame or btn)
                                if clickedDialogSignatures[signature] then break end
                                collectDialogTextFrom(btn)
                                if clickGuiButton(btn) then
                                        clickedDialogSignatures[signature] = true
                                        clickedTotal = clickedTotal + 1
                                end
                                task.wait(0.3)
                        end

                        -- ═══ KIỂM TRA KẾT QUẢ → 3 LỚP PHÁT HIỆN LOCKED ═══
                        --   (a) attribute Locked/IsLocked/Unlocked (prompt→cửa→nhà)
                        --   (b) TEXT thoại chứa "locked/khóa/not home/trở lại sau..."
                        --   (c) Candy không tăng (khi đọc được Candy)
                        if not State.TrickOrTreat then return end
                        local now2 = os.clock()
                        local candyAfter = candyNow()
                        local dlgText = table.concat(DialogueLog, " | ")
                        local doorGone = (best.Parent == nil)
                                or (not bestIsClick and best.Enabled == false)
                        local attrLocked = doorLockedAttribute(best)
                        local hs = houseState[houseKey] or {}
                        houseState[houseKey] = hs

                        if candyReliable and candyAfter > candyBefore then
                                hs.nextVisit = now2 + (State.HouseVisitCooldown or 300)
                                State.StatusText = string.format("Gõ cửa thành công! +Candy (đang có %d)", candyAfter)
                                notify("Trick-or-Treat", string.format("Nhận Candy! (+%d → %d). Nhà tiếp theo!",
                                        candyAfter - candyBefore, candyAfter), "success")
                        elseif attrLocked == true or textSuggestsLocked(dlgText) then
                                -- LOCKED → khóa NGUYÊN CĂN NHÀ, đổi nhà khác NGAY
                                hs.lockUntil = now2 + (State.LockedDoorTime or 180)
                                State.StatusText = "Cửa LOCKED → đổi nhà khác..."
                                notify("Trick-or-Treat", "Nhà này KHÓA — chuyển sang nhà khác.", "warning")
                        elseif clickedTotal > 0 or #DialogueLog > 0 or doorGone then
                                -- Đã tương tác nhưng chưa xác minh được phần thưởng:
                                -- chỉ backoff, không báo thành công giả.
                                hs.nextVisit = now2 + 120
                                State.StatusText = "Đã tương tác cửa nhưng chưa xác minh được Candy — tạm nghỉ nhà này."
                        else
                                -- KHÔNG có gì xảy ra (không thoại, không candy) → backoff
                                hs.fails = (hs.fails or 0) + 1
                                hs.nextVisit = now2 + (hs.fails >= 2 and 90 or 30)
                                State.StatusText = "Cửa không phản hồi — thử nhà khác..."
                        end
                end)
                moveRelease("tot") -- nhả quyền di chuyển sau mỗi cửa
                if not ok then task.wait(1) end
                task.wait(0.3)
                end -- moonActive gate
        end
end

-- ════════════════════════════ 13c. AUTO SPOOKY GACHA (REWRITE v5.1) ═════════
-- ĐẦY ĐỦ chu trình gacha sự kiện:
--   (0) KIỂM TRA CANDY >= giá (slider, mặc định 500) → không đủ → TỰ TẮT.
--       + giới hạn số lượt roll (slider, 0 = vô hạn).
--   (1) Chỉ tìm prompt Zioles và mục Spooky Gacha trong UI.
--   (2) Không gọi RemoteFunction bằng BoxName phỏng đoán.
--   (3) Chỉ tính thành công khi Candy đọc được và giảm đủ giá lượt roll.
--       Server trả lời "hết lượt/giới hạn" (2 lượt/giờ) → TỰ TẮT khỏi spam.
local GachaGen = 0
local gachaRolls = 0
if type(getgenv().MZ_GachaRollTimes) ~= "table" then
        getgenv().MZ_GachaRollTimes = {}
end
local function recentGachaRollCount()
        local now = os.time()
        local times = getgenv().MZ_GachaRollTimes
        for i = #times, 1, -1 do
                if now - times[i] >= 3600 then table.remove(times, i) end
        end
        return #times
end

local GACHA_LIMIT_WORDS = {
        "limit", "already", "come back", "hour", "not enough",
        "giới hạn", "hết lượt", "trở lại", "không đủ",
}

local function gachaRemotePurchase()
        -- Không gọi Remote bằng BoxName phỏng đoán. Spooky Gacha là lựa chọn UI
        -- của Zioles; chỉ tiếp tục khi bắt được đúng nút trong giao diện thật.
        return false, false
end
local function spinnerVisible()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return false end
        local sw = pg:FindFirstChild("SpinnerWindow")
        if not sw then return false end
        if sw:IsA("ScreenGui") then return sw.Enabled end
        if sw:IsA("GuiObject") then return sw.Visible end
        return false
end

local function closeSpinnerWindow()
        pcall(function()
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                local sw = pg and pg:FindFirstChild("SpinnerWindow")
                if sw and spinnerVisible() then
                        local btn = sw:FindFirstChild("AboveSpinner", true)
                        btn = btn and btn:FindFirstChild("Navigation", true)
                        btn = btn and btn:FindFirstChild("CloseButton", true)
                        if btn and btn.Visible and getconnections then
                                for _, c in ipairs(getconnections(btn.MouseButton1Click)) do
                                        pcall(function() c:Fire() end)
                                end
                        end
                end
        end)
end

local function gachaLoop()
        GachaGen = GachaGen + 1
        local myGen = GachaGen
        gachaRolls = 0
        while State.Gacha and myGen == GachaGen and not Unloaded do
                local ok = pcall(function()
                        local root = getRoot()
                        if not root then task.wait(1); return end

                        local price = State.GachaPrice or 500
                        local candyBefore = candyNow()
                        if not candyReliable then
                                State.StatusText = "Không đọc được Candy từ dữ liệu nhân vật; dừng để tránh roll khi không đủ tiền."
                                notify("Spooky Gacha", "Không xác minh được Candy Corn. Chưa thực hiện roll.", "warning")
                                State.Gacha = false
                                return
                        end
                        if candyBefore < price then
                                notify("Spooky Gacha", string.format("Không đủ Candy (%d/%d) — tự tắt.", candyBefore, price), "warning")
                                State.Gacha = false
                                return
                        end
                        if (State.GachaMaxRolls or 0) > 0 and gachaRolls >= State.GachaMaxRolls then
                                notify("Spooky Gacha", "Đã đạt số lượt tối đa của phiên.", "info")
                                State.Gacha = false
                                return
                        end
                        if recentGachaRollCount() >= 2 then
                                notify("Spooky Gacha", "Đã có 2 lượt roll được ghi nhận trong 60 phút qua. Chờ cooldown server.", "warning")
                                State.Gacha = false
                                return
                        end
                        if not moveAcquire("gacha", 20) then return end

                        refreshPumpkins()
                        local bestPrompt, bestDistance, bestPart = nil, math.huge, nil
                        for _, prompt in ipairs(MZ_World.prompts) do
                                local promptText = doorText(prompt)
                                if prompt.Enabled and prompt.Parent
                                        and promptText:find("zioles", 1, true)
                                        and matchKeyword(promptText, State.GachaKeywords)
                                        and (promptText:find("gacha", 1, true)
                                                or promptText:find("talk", 1, true)
                                                or promptText:find("interact", 1, true)) then
                                        local part = doorPart(prompt)
                                        if part then
                                                local distance = (part.Position - root.Position).Magnitude
                                                if distance < bestDistance then
                                                        bestPrompt, bestDistance, bestPart = prompt, distance, part
                                                end
                                        end
                                end
                        end

                        if not bestPrompt then
                                State.StatusText = "Không tìm thấy prompt Zioles/Spooky Gacha trong khu vực hiện tại."
                                moveRelease("gacha")
                                task.wait(3)
                                return
                        end

                        if bestDistance > 8 then
                                local moved = MZ_Tween.to(CFrame.new(safeStandPos(bestPart.Position)), State.TweenSpeed, 4, true, "gacha")
                                local newRoot = getRoot()
                                if not moved or not newRoot or (newRoot.Position - bestPart.Position).Magnitude > 11 then
                                        State.StatusText = "Không tới được Zioles; bỏ qua tương tác để tránh kích hoạt từ xa."
                                        moveRelease("gacha")
                                        return
                                end
                        end
                        faceTarget(bestPart.Position)
                        local fireOk, fireResult = pcall(fireDoor, bestPrompt)
                        if not fireOk or not fireResult then
                                State.StatusText = "Không kích hoạt được prompt Zioles; chưa tiếp tục Gacha."
                                moveRelease("gacha")
                                return
                        end
                        task.wait(0.8)
                        if not State.Gacha or Unloaded then
                                moveRelease("gacha")
                                return
                        end

                        -- Chọn đúng mục event, không thử remote/BoxName không được xác minh.
                        local spookyButton = findGuiButtonWithPhrase("spooky gacha")
                                or findGuiButtonWithPhrase("halloween gacha")
                        if not spookyButton then
                                State.StatusText = "Đã mở NPC; không thấy nút Spooky Gacha. Không tự chọn nhầm Gacha thường."
                                notify("Spooky Gacha", "Không nhận diện được nút Spooky Gacha trong UI. Hãy gửi ảnh giao diện để bổ sung adapter chính xác.", "warning")
                                moveRelease("gacha")
                                task.wait(4)
                                return
                        end
                        local screen = spookyButton:FindFirstAncestorOfClass("ScreenGui")
                        if not screen then
                                State.StatusText = "Nút Spooky Gacha không nằm trong ScreenGui xác định được; dừng an toàn."
                                moveRelease("gacha")
                                return
                        end
                        if not State.Gacha or Unloaded then
                                moveRelease("gacha")
                                return
                        end
                        if not clickGuiButton(spookyButton) then
                                State.StatusText = "Không click được lựa chọn Spooky Gacha."
                                moveRelease("gacha")
                                return
                        end
                        task.wait(0.7)
                        local rollButton = screen and (findGuiButtonWithPhrase("roll", screen)
                                or findGuiButtonWithPhrase("spin", screen)
                                or findGuiButtonWithPhrase("purchase", screen))
                        if not State.Gacha or Unloaded then
                                moveRelease("gacha")
                                return
                        end
                        if not rollButton then
                                State.StatusText = "Đã mở Spooky Gacha; không thấy nút Roll/Spin để xác nhận."
                                moveRelease("gacha")
                                task.wait(3)
                                return
                        end
                        if not State.Gacha or Unloaded then
                                moveRelease("gacha")
                                return
                        end
                        if not clickGuiButton(rollButton) then
                                State.StatusText = "Không click được nút Roll/Spin."
                                moveRelease("gacha")
                                return
                        end

                        local verifyStart = os.clock()
                        local candyAfter = candyBefore
                        while State.Gacha and not Unloaded and os.clock() - verifyStart < 8 do
                                task.wait(0.5)
                                candyAfter = candyNow()
                                if candyReliable and (candyBefore - candyAfter) >= price then break end
                        end
                        if not State.Gacha or Unloaded then
                                State.StatusText = "Đã dừng Gacha theo yêu cầu; không tiếp tục roll."
                                moveRelease("gacha")
                                return
                        end
                        if not candyReliable or (candyBefore - candyAfter) < price then
                                State.StatusText = "Chưa xác minh Candy giảm — không tính là roll thành công và không gửi lần nữa ngay."
                                notify("Spooky Gacha", "UI đã được bấm nhưng Candy chưa giảm; kết quả chưa xác minh.", "warning")
                                State.Gacha = false
                                task.wait(1)
                                moveRelease("gacha")
                                return
                        end

                        gachaRolls = gachaRolls + 1
                        table.insert(getgenv().MZ_GachaRollTimes, os.time())
                        closeSpinnerWindow()
                        notify("Spooky Gacha", string.format("Đã xác minh roll #%d: Candy %d → %d.",
                                gachaRolls, candyBefore, candyAfter), "success")
                        State.StatusText = string.format("Spooky Gacha: xác minh thành công lượt %d.", gachaRolls)
                        task.wait((State.GachaDelay or 3) + math.random() * 1.5)
                        moveRelease("gacha")
                end)
                moveRelease("gacha")
                if not ok then task.wait(1) end
                task.wait(0.5)
        end
end
-- ════════ 13d. AUTO BOSS + MYSTERY HALL (REWRITE v5.1 — STATE MACHINE) ══════
-- Boss event: state machine đầy đủ cho TỪNG boss:
--   • BOSS_DEFS: selector theo toggle (Hellfire Gas / Werewolf / Pumpkin
--     Snowman / Great Pumpkin - Dapper Jack).
--   • Bay TRÊN ĐẦU boss (BCH style) + fast attack AOE + M1 fallback.
--   • Phát hiện boss CHẾT → notify + chờ respawn (không đứng đánh ma).
--   • KHÔNG có boss → Auto Summon Great Pumpkin tại Witch (cooldown nội bộ; cần đủ nguyên liệu).
--   • MOVE BUS: không giành nhân vật với farm / trick-or-treat.
local BOSS_DEFS = {
        { stateKey = "AutoHellfire",     patterns = { "hellfire" },                                 label = "Hellfire Gas" },
        { stateKey = "AutoWerewolf",     patterns = { "werewolf", "wolf" },                        label = "Werewolf" },
        { stateKey = "AutoSnowman",      patterns = { "snowman", "snow man" },                     label = "Pumpkin Snowman" },
        { stateKey = "AutoGreatPumpkin", patterns = { "great pumpkin", "greatpumpkin" }, label = "The Great Pumpkin" },
}

local function anyBossEnabled()
        if State.AutoSummon then return true end
        for _, def in ipairs(BOSS_DEFS) do
                if State[def.stateKey] then return true end
        end
        return false
end

local function findBossByName(patterns)
        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return nil, nil end
        local root = getRoot()
        if not root then return nil, nil end
        local best, bestHRP, bestD = nil, nil, math.huge
        for _, e in ipairs(enemies:GetChildren()) do
                local hrp = e:FindFirstChild("HumanoidRootPart")
                local hum = e:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                        local ln = e.Name:lower()
                        for _, pat in ipairs(patterns) do
                                if ln:find(pat, 1, true) then
                                        local d = (hrp.Position - root.Position).Magnitude
                                        if d < bestD then best, bestHRP, bestD = e, hrp, d end
                                        break
                                end
                        end
                end
        end
        return best, bestHRP
end

local function pickBoss()
        for _, def in ipairs(BOSS_DEFS) do
                local enabled = State[def.stateKey]
                        or (def.stateKey == "AutoGreatPumpkin" and State.AutoSummon)
                if enabled then
                        local boss, hrp = findBossByName(def.patterns)
                        if boss then return boss, hrp, def.label end
                end
        end
        return nil, nil, nil
end

-- 1 chu kỳ đánh boss: bay trên đầu + fast attack + M1 fallback
local function fightBossCycle(bossModel, hrp, forceM1)
        local rootForOffset = getRoot()
        local away = rootForOffset and Vector3.new(rootForOffset.Position.X - hrp.Position.X, 0,
                rootForOffset.Position.Z - hrp.Position.Z) or Vector3.new(1, 0, 0)
        if away.Magnitude < 0.1 then away = Vector3.new(1, 0, 0) end
        local hoverPos = safeStandPosEnemy(hrp.Position + away.Unit * (State.EnemyStandDist or 15))
        local wY = groundwaterY(hoverPos)
        if wY and hoverPos.Y < wY + 3 then
                hoverPos = Vector3.new(hoverPos.X, wY + 3, hoverPos.Z)
        end
        local root = getRoot()
        if not root then return false end
        local reached = true
        if (root.Position - hoverPos).Magnitude > 12 then
                if State.FarmTeleMode then
                        reached = MZ_Teleport(CFrame.new(hoverPos), "boss")
                else
                        reached = MZ_Tween.to(CFrame.new(hoverPos), State.TweenSpeed, 6, true, "boss")
                end
        end
        local rootAfterMove = getRoot()
        if not reached or not rootAfterMove
                or (rootAfterMove.Position - hrp.Position).Magnitude > (State.HitRange or 30) + 12 then
                State.StatusText = "Chưa tới tầm đánh boss; tạm không gửi đòn đánh từ xa."
                return false
        end
        faceTarget(hrp.Position)
        equipFightingStyle()
        if forceM1 then
                CombatRemoteFails = 0
                hitPumpkinM1(hrp.Position)
                return
        end
        if hitEnemiesFastAttack({ [bossModel] = true }) then
                CombatRemoteFails = 0
        else
                CombatRemoteFails = CombatRemoteFails + 1
                if CombatRemoteFails >= 3 then
                        hitPumpkinM1(hrp.Position) -- remote không khởi chạy → M1 fallback
                end
        end
end

-- Đọc nguyên liệu Great Pumpkin theo tên chính xác. Không cộng mirror Data/leaderstats.
-- Nếu game lưu bằng module/table không expose ValueBase hoặc Tool, trả nil để cần nối runtime.
local function normalizedItemName(value)
        return (value or ""):lower():gsub("[^%w]", "")
end

local EVENT_ITEM_ALIASES = {
        pumpkinbits = { pumpkinbits = true, pumpkinbit = true },
        cursedpumpkinseed = {
                cursedpumpkinseed = true, cursedpumpkinseeds = true,
                pumpkinseed = true, pumpkinseeds = true,
        },
}

local function readEventItemCount(targetName)
        local aliases = EVENT_ITEM_ALIASES[targetName] or { [targetName] = true }
        local pl = LocalPlayer
        -- Ưu tiên Inventory/Backpack; lấy một nguồn đầu tiên để tránh cộng trùng
        -- Data/leaderstats nếu game mirror cùng một vật phẩm ở nhiều nơi.
        local roots = {
                pl:FindFirstChild("Inventory"), pl:FindFirstChild("Backpack"),
                pl:FindFirstChild("Data"), pl:FindFirstChild("PlayerData"),
                pl:FindFirstChild("leaderstats"), pl.Character, pl,
        }
        for _, container in ipairs(roots) do
                if container then
                        local foundValue = nil
                        pcall(function()
                                if aliases[normalizedItemName(container.Name)] then
                                        if container:IsA("IntValue") or container:IsA("NumberValue")
                                                or container:IsA("IntConstrainedValue") then
                                                foundValue = tonumber(container.Value)
                                        elseif container:IsA("Tool") then
                                                foundValue = 1
                                        end
                                end
                                for _, item in ipairs(container:GetDescendants()) do
                                        if aliases[normalizedItemName(item.Name)] then
                                                if item:IsA("IntValue") or item:IsA("NumberValue")
                                                        or item:IsA("IntConstrainedValue") then
                                                        foundValue = tonumber(item.Value)
                                                        break
                                                elseif item:IsA("Tool") then
                                                        foundValue = (foundValue or 0) + 1
                                                end
                                        end
                                end
                        end)
                        if foundValue ~= nil then return foundValue end
                end
        end
        return nil
end

local function readGreatPumpkinRequirements()
        return readEventItemCount("pumpkinbits"), readEventItemCount("cursedpumpkinseed")
end

-- Auto Summon: chỉ tương tác Witch sau khi xác minh đủ 200 Bits + 3 Seeds.
local summonLastFired = 0
local function fireSummonPrompt()
        if not State.AutoSummon or Unloaded then return false end
        local bits, seeds = readGreatPumpkinRequirements()
        if bits == nil or seeds == nil then
                State.StatusText = "Không đọc được Pumpkin Bits/Cursed Pumpkin Seeds từ Inventory; chưa tương tác Witch."
                notify("Great Pumpkin", "Không xác minh được 200 Pumpkin Bits + 3 Cursed Pumpkin Seeds. Cần kiểm tra cấu trúc Inventory runtime.", "warning")
                return false
        end
        if bits < 200 or seeds < 3 then
                State.StatusText = string.format("Thiếu nguyên liệu Great Pumpkin: %d/200 Bits, %d/3 Seeds.", bits, seeds)
                return false
        end
        refreshPumpkins()
        for _, pr in ipairs(MZ_World.prompts) do
                if pr.Enabled and pr.Parent then
                        local txt = doorText(pr)
                        if txt:find("witch", 1, true) or txt:find("cauldron", 1, true) then
                                local part = doorPart(pr)
                                local root = getRoot()
                                if part and root then
                                        local d = (part.Position - root.Position).Magnitude
                                        if d > 8 then
                                                State.StatusText = "Bay tới Witch để chọn Great Pumpkin..."
                                                local moved
                                                if State.FarmTeleMode then
                                                        moved = MZ_Teleport(CFrame.new(safeStandPos(part.Position)), "boss")
                                                else
                                                        moved = MZ_Tween.to(CFrame.new(safeStandPos(part.Position)),
                                                                State.TweenSpeed, 4, true, "boss")
                                                end
                                                local afterRoot = getRoot()
                                                if not moved or not afterRoot
                                                        or (afterRoot.Position - part.Position).Magnitude > 11 then
                                                        State.StatusText = "Không tới được Witch; bỏ qua để tránh kích hoạt từ xa."
                                                        return false
                                                end
                                        end
                                        if not State.AutoSummon or Unloaded then return false end
                                        faceTarget(part.Position)
                                        local promptCallOk, promptFired = pcall(fireDoor, pr)
                                        if not promptCallOk or not promptFired then
                                                State.StatusText = "Không kích hoạt được prompt Witch."
                                                return false
                                        end
                                        task.wait(0.8)
                                        if not State.AutoSummon or Unloaded then return false end
                                        local option = findGuiButtonWithPhrase("i want to fight the great pumpkin")
                                        if option then
                                                local clicked = clickGuiButton(option)
                                                if clicked then
                                                        State.StatusText = "Đã chọn Witch: Fight the Great Pumpkin; chờ server xác nhận nguyên liệu..."
                                                        return true
                                                end
                                                State.StatusText = "Tìm thấy lựa chọn Great Pumpkin nhưng không click được; không báo summon thành công."
                                                return false
                                        end
                                        State.StatusText = "Đã mở Witch; không tìm thấy lựa chọn Fight the Great Pumpkin — không tự bấm nhầm lựa chọn khác."
                                        return false
                                end
                        end
                end
        end
        return false
end

local BossGen = 0
local BossHealthTrack = setmetatable({}, { __mode = "k" })
local function bossLoop()
        BossGen = BossGen + 1
        local myGen = BossGen
        while anyBossEnabled() and myGen == BossGen and not Unloaded do
                local ok, err = pcall(function()
                        local root = getRoot()
                        if not root then task.wait(1); return end
                        local boss, hrp, label = pickBoss()
                        if not boss then
                                State.StatusText = "Đang chờ boss spawn..."
                                if State.AutoSummon and os.clock() - summonLastFired > 45 then
                                        if moveAcquire("boss", 8) then
                                                summonLastFired = os.clock()
                                                local selected = fireSummonPrompt()
                                                moveRelease("boss")
                                                if selected then
                                                        notify("Auto Summon", "Đã gửi lựa chọn Witch; chờ server xác nhận boss xuất hiện.", "info")
                                                end
                                        end
                                end
                                task.wait(2)
                                return
                        end
                        -- Chỉ giữ quyền di chuyển cho một chu kỳ; không khóa các hệ thống khác suốt trận boss.
                        if not moveAcquire("boss", 8) then return end
                        local currentHum = boss:FindFirstChildOfClass("Humanoid")
                        local currentRoot = boss:FindFirstChild("HumanoidRootPart")
                        if not currentHum or currentHum.Health <= 0 or not currentRoot then
                                notify("Boss", (label or boss.Name) .. " đã bị hạ hoặc biến mất; chờ spawn lại.", "success")
                                State.StatusText = "Boss đã chết/biến mất — chờ respawn..."
                        else
                                local now = os.clock()
                                local hp = currentHum.Health
                                local track = BossHealthTrack[boss]
                                if not track then
                                        track = { lastHealth = hp, lastDamageAt = now, lastProbeAt = 0 }
                                        BossHealthTrack[boss] = track
                                elseif hp < track.lastHealth - 0.1 then
                                        track.lastHealth = hp
                                        track.lastDamageAt = now
                                        track.lastProbeAt = 0
                                elseif hp > track.lastHealth + 0.1 then
                                        track.lastHealth = hp
                                        track.lastDamageAt = now
                                end

                                local stalled = now - track.lastDamageAt
                                if stalled < 6 then
                                        State.StatusText = "Đang đánh boss: " .. boss.Name
                                        fightBossCycle(boss, currentRoot, false)
                                elseif now - track.lastProbeAt >= 2.5 then
                                        -- Có thể boss đang ở phase bất tử/transition hoặc remote không ăn.
                                        -- Thử M1 thưa, không spam Fast Attack liên tục.
                                        track.lastProbeAt = now
                                        State.StatusText = "Boss chưa mất máu 6s; kiểm tra phase/đổi M1 thưa..."
                                        fightBossCycle(boss, currentRoot, true)
                                else
                                        State.StatusText = "Boss có thể đang miễn nhiễm/transition; tạm chờ phase kế tiếp..."
                                        task.wait(0.25)
                                end
                        end
                        moveRelease("boss")
                        task.wait(0.12 + math.random() * 0.08)
                end)
                moveRelease("boss")
                if not ok then
                        State.StatusText = "Boss loop gặp lỗi; tự thử lại: " .. tostring(err)
                        task.wait(1)
                end
                task.wait(0.15)
        end
end

-- ═══ v5.2: MONSTER CHASE WATCHER — chỉ nhận diện UI, không đoán đáp án ═══
local HallGen = 0
local function mysteryHallLoop()
        HallGen = HallGen + 1
        local myGen = HallGen
        local notified = false
        while State.MysteryHall and myGen == HallGen and not Unloaded do
                local detected = false
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if pg then
                        pcall(function()
                                for _, gui in ipairs(pg:GetChildren()) do
                                        if gui:IsA("ScreenGui") and gui.Enabled then
                                                local name = (gui.Name or ""):lower()
                                                if name:find("hall", 1, true) or name:find("chase", 1, true)
                                                        or name:find("oni", 1, true) then
                                                        detected = true
                                                        break
                                                end
                                                for _, item in ipairs(gui:GetDescendants()) do
                                                        if item:IsA("TextLabel") then
                                                                local t = (item.Text or ""):lower()
                                                                if t:find("oni", 1, true) or t:find("which room", 1, true)
                                                                        or t:find("monster chase", 1, true) then
                                                                        detected = true
                                                                        break
                                                                end
                                                        end
                                                end
                                                if detected then break end
                                        end
                                end
                        end)
                end
                if detected then
                        State.StatusText = "Đã phát hiện UI hành lang Oni/Monster Chase. Cần quan sát 6 phòng và chọn đúng phòng; script chưa tự đoán đáp án."
                        if not notified then
                                notified = true
                                notify("Monster Chase", "Đã nhận diện minigame. Tạm không click/tele tự động để tránh chọn sai phòng.", "warning")
                        end
                else
                        State.StatusText = "Đang chờ giao diện Monster Chase / Numbered Hallway..."
                        notified = false
                end
                task.wait(2)
        end
end

-- ═══ v5.1: KIỂM TRA EVENT CÓ ĐANG HOẠT ĐỘNG ═══
-- (gõ cửa thường chỉ mở ĐẦU GIỜ XX:00 → cảnh báo nếu không thấy dấu hiệu)
isHarvestMoonWindow = function()
        local ok, serverTime = pcall(function() return workspace:GetServerTimeNow() end)
        if not ok or type(serverTime) ~= "number" then return nil end
        local secondsIntoHour = serverTime % 3600
        return secondsIntoHour < 600 -- XX:00 đến XX:09:59 theo giờ server/UTC
end

local function eventLooksActive()
        refreshPumpkins(true)
        if #MZ_World.pumpkins > 0 then return true end
        local hasDoor = false
        for _, pr in ipairs(MZ_World.prompts) do
                if pr.Parent and matchKeyword(doorText(pr), State.KnockKeywords) then
                        hasDoor = true
                        break
                end
        end
        if hasDoor then return true end
        local found = false
        pcall(function()
                for _, d in ipairs(workspace:GetChildren()) do
                        local n = (d.Name or ""):lower()
                        if n:find("halloween", 1, true) or n:find("harvest", 1, true) then
                                found = true
                                break
                        end
                end
        end)
        return found
end

-- ═══ v5.1: CHẨN ĐOÁN — in cửa + GUI ra console (gửi cho dev nếu lỗi) ═══
local function diagnoseEvent()
        task.spawn(function()
                print("════ [MZ Halloween] CHẨN ĐOÁN EVENT ════")
                pcall(function()
                        refreshPumpkins(true)
                        print(string.format("Pumpkins: %d | Patches: %d | Prompts: %d | Clickers: %d",
                                #MZ_World.pumpkins, #MZ_World.patches, #MZ_World.prompts, #MZ_World.clickers))
                        local root = getRoot()
                        local n = 0
                        for _, pr in ipairs(MZ_World.prompts) do
                                if pr.Parent and n < 25 then
                                        local txt = doorText(pr)
                                        local isDoor = matchKeyword(txt, State.KnockKeywords)
                                        local part = doorPart(pr)
                                        local d = (root and part)
                                                and math.floor((part.Position - root.Position).Magnitude) or -1
                                        if isDoor or (d >= 0 and d < 400) then
                                                n = n + 1
                                                print(string.format("[PROMPT]%s d=%dm | %s",
                                                        isDoor and " (CỬA?)" or "", d, txt))
                                        end
                                end
                        end
                        local pg = LocalPlayer:FindFirstChild("PlayerGui")
                        if pg then
                                print("──── PlayerGui ────")
                                for _, sg in ipairs(pg:GetChildren()) do
                                        local vis = sg:IsA("ScreenGui") and sg.Enabled or false
                                        print(string.format("[GUI] %s (Enabled=%s)", sg.Name, tostring(vis)))
                                        if vis and not isExcludedGui(sg) then
                                                local m = 0
                                                for _, d in ipairs(sg:GetDescendants()) do
                                                        if (d:IsA("TextButton") or d:IsA("ImageButton"))
                                                                        and guiVisibleChain(d) and m < 10 then
                                                                m = m + 1
                                                                print(string.format("    [BTN] %s | Text=%s",
                                                                        d.Name, d:IsA("TextButton") and tostring(d.Text) or ""))
                                                        end
                                                end
                                        end
                                end
                        end
                end)
                print("════ [MZ Halloween] HẾT CHẨN ĐOÁN (gửi console này cho dev nếu còn lỗi) ════")
        end)
end

-- ════════════════════════════ 14. ESP BÍ NGÔ ══════════════════════════════
-- Viết lại từ ESP Pumpkin gốc của bạn + thêm tag khoảng cách + đổi màu live
local ESPObjects = {} -- [model] = { hl, bb, label, kind }

local function espRemove(model)
        local o = ESPObjects[model]
        if o then
                pcall(function() if o.hl then o.hl:Destroy() end end)
                pcall(function() if o.bb then o.bb:Destroy() end end)
                ESPObjects[model] = nil
        end
end

local function espClearAll()
        for m in pairs(ESPObjects) do
                espRemove(m)
        end
        ESPObjects = {}
end

local ESP_CAP = 100 -- giới hạn số Highlight để không tụt FPS

local function espApply(model, kind)
        if ESPObjects[model] then return end
        local n = 0
        for _ in pairs(ESPObjects) do
                n = n + 1
                if n >= ESP_CAP then return end
        end
        local r = modelRoot(model)
        if not r then return end
        local hl = Instance.new("Highlight")
        hl.Name = "MZ_Halloween_ESP"
        hl.FillColor = State.ESPFill
        hl.OutlineColor = State.ESPOutline
        hl.FillTransparency = 0.25
        hl.OutlineTransparency = 0
        hl.Adornee = model
        hl.Parent = model

        local bb = Instance.new("BillboardGui")
        bb.Name = "MZ_Halloween_ESP_Tag"
        bb.Adornee = r
        bb.Size = UDim2.new(0, 170, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 2500

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = kind == "patch" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 170, 60)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.Text = kind == "patch" and "🎃 PumpkinPatch" or "🎃 Pumpkin"
        label.Parent = bb

        bb.Parent = r
        ESPObjects[model] = { hl = hl, bb = bb, label = label, kind = kind }
end

local function espScan()
        local cam = workspace.CurrentCamera
        local camPos = cam and cam.CFrame.Position
        local maxR = State.ESPMaxRange
        refreshPumpkins() -- cache chung — không quét đè (giảm lag)
        local patches = MZ_World.patches

        if State.ESP then
                for _, m in ipairs(MZ_World.pumpkins) do
                        local r = modelRoot(m)
                        if r and camPos and isEventPumpkinTarget(m, r, patches) then
                                if maxR <= 0 or (r.Position - camPos).Magnitude <= maxR then
                                        espApply(m, "pumpkin")
                                end
                        end
                end
        end
        if State.ESPPatch then
                for _, m in ipairs(MZ_World.patches) do
                        local r = modelRoot(m)
                        if r and camPos then
                                if maxR <= 0 or (r.Position - camPos).Magnitude <= maxR then
                                        espApply(m, "patch")
                                end
                        end
                end
        end

        -- dọn ESP thừa
        for m, o in pairs(ESPObjects) do
                local dead = m.Parent == nil
                if not dead and camPos then
                        local r = modelRoot(m)
                        if not r or (o.kind == "pumpkin" and not State.ESP)
                                or (o.kind == "patch" and not State.ESPPatch)
                                or (maxR > 0 and (r.Position - camPos).Magnitude > maxR + 50) then
                                dead = true
                        end
                end
                if dead then
                        espRemove(m)
                end
        end
end

local EspGen = 0
local function espLoop()
        EspGen = EspGen + 1
        local myGen = EspGen
        while (State.ESP or State.ESPPatch) and myGen == EspGen do
                pcall(espScan)
                task.wait(2)
        end
        if myGen == EspGen then
                espClearAll()
        end
end

local EspLabelGen = 0
local function espLabelLoop()
        EspLabelGen = EspLabelGen + 1
        local myGen = EspLabelGen
        while (State.ESP or State.ESPPatch) and myGen == EspLabelGen do
                local cam = workspace.CurrentCamera
                local camPos = cam and cam.CFrame.Position
                if camPos then
                        for m, o in pairs(ESPObjects) do
                                local r = modelRoot(m)
                                pcall(function()
                                        if r and o.label then
                                                if State.ESPDistance then
                                                        o.label.Text = (o.kind == "patch" and "🎃 Patch • " or "🎃 Pumpkin • ")
                                                                .. tostring(math.floor((r.Position - camPos).Magnitude + 0.5)) .. "m"
                                                else
                                                        o.label.Text = o.kind == "patch" and "🎃 PumpkinPatch" or "🎃 Pumpkin"
                                                end
                                        end
                                end)
                        end
                end
                task.wait(0.4)
        end
end

-- ════════════════════════════ 14b. GIẢM LAG / NO FX AN TOÀN ═══════════════
-- Tắt hiệu ứng TRỰC QUAN an toàn (particle / lửa / khói / sáng).
-- KHÔNG đụng Beam / Trail — vì script hiệu ứng của game tham chiếu chúng
-- (VD lỗi "Beam is not a valid member of Part 'StartBeam'" của
--  ReplicatedStorage.EffectContainer.Hellfire.Transformed.Z — lỗi game,
--  mình không phá Beam để tránh làm lỗi nặng hơn).
local NOFX_CLASSES = {
        ParticleEmitter = true,
        Fire = true,
        Smoke = true,
        Sparkles = true,
        PointLight = true,
        SurfaceLight = true,
        SpotLight = true,
}

local nofxConn = nil
local OriginalFXEnabled = setmetatable({}, { __mode = "k" })

local function nofxDisable(d)
        if not NOFX_CLASSES[d.ClassName] then return end
        pcall(function()
                if OriginalFXEnabled[d] == nil then OriginalFXEnabled[d] = d.Enabled end
                d.Enabled = false
        end)
end

local function nofxSweep(container)
        for _, d in ipairs(container:GetDescendants()) do nofxDisable(d) end
end

local function setNoFX(on)
        if on then
                if not nofxConn then
                        nofxConn = workspace.DescendantAdded:Connect(function(d)
                                if NOFX_CLASSES[d.ClassName] then
                                        task.defer(function() if d.Parent then nofxDisable(d) end end)
                                end
                        end)
                        table.insert(Connections, nofxConn)
                end
                nofxSweep(workspace)
        else
                if nofxConn then pcall(function() nofxConn:Disconnect() end); nofxConn = nil end
                for obj, oldEnabled in pairs(OriginalFXEnabled) do
                        if obj and obj.Parent then pcall(function() obj.Enabled = oldEnabled end) end
                        OriginalFXEnabled[obj] = nil
                end
        end
end

-- ════════════════════════════ 15. HOP SERVER ══════════════════════════════
getgenv().MZ_VisitedServers = getgenv().MZ_VisitedServers or {}

local function serverList()
        local servers = {}
        local cursor = ""
        for _ = 1, 3 do
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
                        .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
                        .. (cursor ~= "" and ("&cursor=" .. cursor) or "")
                local ok, res = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet(url))
                end)
                if not ok or type(res) ~= "table" or type(res.data) ~= "table" then
                        break
                end
                for _, s in ipairs(res.data) do
                        if s.id ~= game.JobId and (s.playing or 0) < (s.maxPlayers or 0) then
                                table.insert(servers, s.id)
                        end
                end
                cursor = res.nextPageCursor or ""
                if cursor == "" then break end
        end
        return servers
end

local function hopServer()
        local visited = getgenv().MZ_VisitedServers
        local list = serverList()
        local fresh = {}
        for _, id in ipairs(list) do
                if not visited[id] then
                        table.insert(fresh, id)
                end
        end
        local pool = (#fresh > 0) and fresh or list
        if #pool == 0 then
                notify("Hop Server", "Không tìm thấy server nào khác!", "error")
                return
        end
        local job = pool[math.random(1, #pool)]
        visited[job] = true
        -- chỉ nhớ 20 server gần nhất
        local n = 0
        for id in pairs(visited) do
                n = n + 1
                if n > 20 then visited[id] = nil end
        end
        notify("Hop Server", "Đang chuyển server...", "info")
        task.wait(0.5)
        pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, job, LocalPlayer)
        end)
end

-- ════════════════════════════ 16. NẠP THƯ VIỆN MEIZU ══════════════════════
Library = getgenv().MeizuLibrary
if type(Library) ~= "table" or type(Library.CreateWindow) ~= "function" then
        Library = nil
        local httpOk, source = pcall(function()
                return game:HttpGet(MEIZU_LIBRARY_URL)
        end)
        if not httpOk or type(source) ~= "string" or source == "" then
                error("[MZ Halloween] Không tải được MeizuLibrary.lua: " .. tostring(source))
        end
        local compileOk, chunkOrError = pcall(loadstring, source)
        if not compileOk or type(chunkOrError) ~= "function" then
                error("[MZ Halloween] MeizuLibrary.lua không compile được: " .. tostring(chunkOrError))
        end
        local runOk, loadedLibrary = pcall(chunkOrError)
        if not runOk or type(loadedLibrary) ~= "table"
                or type(loadedLibrary.CreateWindow) ~= "function" then
                error("[MZ Halloween] MeizuLibrary.lua không trả về API CreateWindow hợp lệ: " .. tostring(loadedLibrary))
        end
        Library = loadedLibrary
        getgenv().MeizuLibrary = Library
end

local Window = Library:CreateWindow({
        Title = "Meizu Hub",
        SubTitle = "Halloween Event 2026 🎃",
        Theme = "Midnight",
        Accent = Color3.fromRGB(255, 120, 0), -- cam halloween
        ToggleKeybind = Enum.KeyCode.LeftControl,
        Size = UDim2.fromOffset(640, 470),
})

-- Forward-declare statusPara de section 21 state loop co the truy cap (UI block scope)
local statusPara

-- ════════════════════════════ 17. TAB: FARM BÍ NGÔ ════════════════════════
-- v5.2.1: UI building gói trong local function buildUI() de giai phong local registers
-- (Luau gioi han 200 local/function; do...end KHONG giai phong register khi outer local
--  bi closure capture -> phai dung function de co 200-register limit rieng)
local function buildUI()
local TabFarm = Window:CreateTab("Farm Bí Ngô")
local SecStatus = TabFarm:CreateSection("Trạng Thái")

statusPara = SecStatus:CreateParagraph({
        Title = "🎃 Jack O' Lantern Hunt",
        Content = "Bí ngô khả dụng: ... | Trạng thái: Tắt",
})

local SecFarm = TabFarm:CreateSection("Auto Farm Bí Ngô")

SecFarm:CreateToggle({
        Title = "Bật Auto Farm Bí Ngô",
        Description = "Chỉ chọn bí ngô trong PumpkinPatch/được đánh dấu; giới hạn quanh vị trí bật farm.",
        Default = false,
        Callback = function(v)
                State.FarmPumpkin = v
                if v then
                        task.spawn(farmLoop)
                        if State.PickupDrops then
                                task.spawn(pickupLoop)
                        end
                        notify("Farm Bí Ngô", "Đã BẬT auto farm bí ngô!", "success")
                        -- chống bấm nhầm UI: tự thu nhỏ Hub sau 1.5s (Ctrl trái mở lại)
                        if State.HideUIFarm and Window.IsOpen and Window:IsOpen() then
                                task.delay(1.5, function()
                                        if State.FarmPumpkin and Window.IsOpen and Window:IsOpen() then
                                                pcall(function() Window:Toggle(false) end)
                                                notify("Farm Bí Ngô", "Đã thu nhỏ Hub — nhấn CTRL TRÁI để mở lại.", "info")
                                        end
                                end)
                        end
                else
                        MZ_Tween.cancel("farm")
                        State.StatusText = "Tắt"
                        notify("Farm Bí Ngô", "Đã TẮT auto farm.", "warning")
                end
        end,
})

SecFarm:CreateToggle({
        Title = "Tự Bật Buso Haki (Aura)",
        Description = "Tự kích hoạt Haki Vũ Sắc khi đánh — đập bí ngô đau hơn hẳn, không cần bật tay.",
        Default = true,
        Callback = function(v)
                State.AutoBuso = v
                if v then
                        enableBuso()
                        task.spawn(busoLoop)
                        notify("Auto Buso", "Đã BẬT Buso Haki (Aura).", "success")
                else
                        notify("Auto Buso", "Đã TẮT Buso Haki.", "warning")
                end
        end,
})

-- StandDist cố định = 1 (kế bên bí ngô) — KHÔNG cho chỉnh nữa (yêu cầu owner)

SecFarm:CreateDropdown({
        Title = "Chế độ farm",
        Options = { "Tới gần từng bí ngô", "Đập trong tầm (tự đuổi khi trống)" },
        Default = State.FarmMode,
        Callback = function(opt)
                State.FarmMode = opt
        end,
})

SecFarm:CreateToggle({
        Title = "Tele mode (BCH style, không tween)",
        Description = "BẬT = set CFrame tức thì (tele, giống Banana Cat Hub farm). TẮT = tween bay từng bước. Tele nhanh hơn, không kẹt terrain.",
        Default = false,
        Callback = function(v)
                State.FarmTeleMode = v
                notify("Farm Tele", v and "Đã BẬT tele mode (BCH style)." or "Đã TẮT — dùng tween.", v and "success" or "info")
        end,
})

SecFarm:CreateDropdown({
        Title = "Lọc bí ngô",
        Options = { "Tất cả bí ngô", "Bỏ qua bí ngô sống/boss" },
        Default = State.FilterMode,
        Callback = function(opt)
                State.FilterMode = opt
        end,
})

SecFarm:CreateSlider({
        Title = "Tốc độ di chuyển (MAX 230)",
        Description = "Giới hạn 230 studs/s theo yêu cầu — vượt sẽ bị anticheat kéo về.",
        Min = 100, Max = 230, Default = State.TweenSpeed, Rounding = 0, Suffix = " studs/s",
        Callback = function(v)
                State.TweenSpeed = math.clamp(v, 20, 230)
        end,
})

SecFarm:CreateSlider({
        Title = "Bán kính farm quanh vị trí bật",
        Description = "Giới hạn vùng tìm mục tiêu để tránh đuổi bí ngô xa xuyên map",
        Min = 100, Max = 2000, Default = State.MaxFarmDistance, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.MaxFarmDistance = v
        end,
})

SecFarm:CreateSlider({
        Title = "Tầm đập",
        Min = 10, Max = 80, Default = State.HitRange, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.HitRange = v
        end,
})

SecFarm:CreateSlider({
        Title = "Delay mỗi hit",
        Min = 0.05, Max = 1, Default = State.HitDelay, Rounding = 2, Suffix = "s",
        Callback = function(v)
                State.HitDelay = v
        end,
})

SecFarm:CreateToggle({
        Title = "Remote cho Pumpkin (RegisterHit)",
        Description = "MẶC ĐỊNH TẮT — server đa số CHẶN remote với bí ngô. Để TẮT = pumpkin đánh M1 người thật. (Quái Jack o' Lantern LUÔN dùng fast attack remote kiểu BCH — không cần toggle này.)",
        Default = false,
        Callback = function(v)
                State.FastAttack = v
                AtkMethod = v and "remote" or "m1"
                if v then
                        notify("Fast Attack", "Đang dùng remote cho PUMPKIN — nếu bí ngô không mất máu thì TẮT. (Jack o' Lantern vẫn dùng fast attack.)", "warning")
                end
        end,
})

SecFarm:CreateToggle({
        Title = "Noclip khi farm",
        Description = "Xuyên tường/nóc/cây để đứng ngang tầm bí ngô. TẮT hoặc unload → TỰ KHÔI PHỤC collision (v5.1).",
        Default = true,
        Callback = function(v)
                State.Noclip = v
                if not v then
                        restoreCollisions() -- v5.1: khôi phục collision khi tắt
                end
                notify("Noclip", v and "Đã BẬT." or "Đã TẮT (đã khôi phục collision).", v and "success" or "warning")
        end,
})

-- Chống chạm nước: tự động ( KHÔNG cần toggle) — FloatForce + bump trong
-- tween/tele xử lý trực tiếp. Devil Fruit user an toàn.

SecFarm:CreateToggle({
        Title = "Tự nhặt đồ rơi",
        Description = "Tự chạm các drop Candy Corn / Pumpkin Bits gần nhân vật; chỉ hoạt động khi drop được nhận diện trong Workspace.",
        Default = true,
        Callback = function(v)
                State.PickupDrops = v
                if v then
                        task.spawn(pickupLoop)
                end
                notify("Nhặt đồ", v and "Đã BẬT tự nhặt Candy Corn." or "Đã TẮT.", v and "success" or "warning")
        end,
})

SecFarm:CreateToggle({
        Title = "Tự thu nhỏ Hub khi farm",
        Description = "KHUYẾN NGHỊ BẬT — ẩn UI để click ảo KHÔNG bấm nhầm nút Hub (chính là nguyên nhân farm tự tắt trước đây). Nhấn Ctrl trái để mở lại Hub.",
        Default = true,
        Callback = function(v)
                State.HideUIFarm = v
                if not v and Window.IsOpen and not Window:IsOpen() then
                        pcall(function() Window:Toggle(true) end)
                end
                notify("Thu nhỏ Hub", v and "Sẽ tự ẩn Hub khi farm (Ctrl trái mở lại)." or "Sẽ giữ Hub hiện.", "info")
        end,
})

SecFarm:CreateSlider({
        Title = "Bán kính nhặt đồ",
        Min = 20, Max = 300, Default = State.PickupRadius, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.PickupRadius = v
        end,
})

SecFarm:CreateInput({
        Title = "Từ khóa đồ rơi (phân cách bằng ,)",
        Placeholder = "candy,corn,pumpkin,bit,spooky",
        Default = State.PickupKeywords,
        Callback = function(text)
                State.PickupKeywords = text or ""
        end,
})

-- ════════════════════════════ 18. TAB: ESP ════════════════════════════════
local TabESP = Window:CreateTab("ESP Bí Ngô")
local SecESPMain = TabESP:CreateSection("ESP Pumpkin (Jack O' Lantern)")

SecESPMain:CreateToggle({
        Title = "ESP Bí Ngô",
        Description = "Highlight mọi bí ngô trong map",
        Default = false,
        Callback = function(v)
                State.ESP = v
                task.spawn(espLoop)
                task.spawn(espLabelLoop)
                notify("ESP Bí Ngô", v and "Đã BẬT ESP bí ngô." or "Đã TẮT ESP.", v and "success" or "warning")
        end,
})

SecESPMain:CreateToggle({
        Title = "ESP PumpkinPatch (vùng)",
        Default = false,
        Callback = function(v)
                State.ESPPatch = v
                task.spawn(espLoop)
                task.spawn(espLabelLoop)
                notify("ESP Patch", v and "Đã BẬT ESP vùng PumpkinPatch." or "Đã TẮT.", v and "success" or "warning")
        end,
})

SecESPMain:CreateToggle({
        Title = "Hiện khoảng cách",
        Default = true,
        Callback = function(v)
                State.ESPDistance = v
        end,
})

SecESPMain:CreateSlider({
        Title = "Bán kính hiện ESP",
        Min = 0, Max = 5000, Default = 0, Rounding = 0, Suffix = " studs (0 = vô hạn)",
        Callback = function(v)
                State.ESPMaxRange = v
        end,
})

local SecESPColor = TabESP:CreateSection("Màu ESP")

SecESPColor:CreateColorPicker({
        Title = "Màu fill",
        Default = State.ESPFill,
        Callback = function(c)
                State.ESPFill = c
                for _, o in pairs(ESPObjects) do
                        pcall(function() o.hl.FillColor = c end)
                end
        end,
})

SecESPColor:CreateColorPicker({
        Title = "Màu viền",
        Default = State.ESPOutline,
        Callback = function(c)
                State.ESPOutline = c
                for _, o in pairs(ESPObjects) do
                        pcall(function() o.hl.OutlineColor = c end)
                end
        end,
})

SecESPColor:CreateButton({
        Title = "Làm mới ESP",
        Callback = function()
                espClearAll()
                task.spawn(espScan)
                notify("ESP", "Đã làm mới ESP!", "success")
        end,
})

-- ════════════════════════════ 19. TAB: SỰ KIỆN (FULL v5.0) ═════════════════
-- Cấu trúc menu giống script event khác (ảnh user gửi):
--   [Trick or Treat]  : Auto Trick or Treat / Auto Spooky Gacha
--   [Great Pumpkin]   : Auto Great Pumpkin / Auto Summon / Ignore Jack o' Lantern /
--                       Ignore Pumpkin Snowman / Break Rare Pumpkin Only
--   [Boss]            : Auto Hellfire Gas / Auto Werewolf
local TabEvent = Window:CreateTab("Sự Kiện")
local SecEventInfo = TabEvent:CreateSection("Thông Tin Event Hellfire")

SecEventInfo:CreateParagraph({
        Title = "👻 Halloween 2026",
        Content = "• Harvest Moon/Trick or Treat: 10 phút đầu mỗi giờ server (XX:00–XX:09)\n"
                .. "• Pumpkin và Pumpkin Snowman: farm ngoài Harvest Moon; Bits/Seeds dùng tại Witch\n"
                .. "• Great Pumpkin: 200 Pumpkin Bits + 3 Cursed Pumpkin Seeds tại Witch\n"
                .. "• Spooky Gacha tại Zioles: 500 Candy Corn/lượt, tối đa 2 lượt/giờ; cooldown chung Gacha thường\n"
                .. "• Harvest Moon có nhiều kiểu cửa/minigame; script chỉ tự bấm Continue, không tự đoán đáp án.",
})

-- ── TRICK OR TREAT ──
local SecDoor = TabEvent:CreateSection("🎃 Trick or Treat")

SecDoor:CreateToggle({
        Title = "Auto Trick or Treat",
        Description = "Tìm cửa trong Harvest Moon, tương tác và chỉ bấm Continue khi nhận diện được hội thoại thông thường; đánh quái mới trong danh sách theo dõi. Màn hình lựa chọn/minigame sẽ dừng để tránh chọn sai; kết quả chỉ xác nhận khi Candy tăng.",
        Default = false,
        Callback = function(v)
                State.TrickOrTreat = v
                if v then
                        -- v5.1: kiểm tra event có đang hoạt động không (cửa chỉ mở đầu giờ XX:00)
                        if not eventLooksActive() then
                                notify("Trick-or-Treat",
                                        "⚠ Chưa thấy dấu hiệu event (cửa thường chỉ mở ĐẦU GIỜ XX:00).\nVẫn chạy — nếu không gõ được gì thì chờ tới đầu giờ.", "warning")
                        end
                        task.spawn(doorLoop)
                        if State.PickupDrops then
                                task.spawn(pickupLoop)
                        end
                        notify("Trick-or-Treat", "Đã BẬT!\nTự bấm thoại + đánh quái spawn + đổi nhà khi khóa.", "success")
                else
                        MZ_Tween.cancel("tot")
                        notify("Trick-or-Treat", "Đã TẮT.", "warning")
                end
        end,
})

SecDoor:CreateToggle({
        Title = "Auto Spooky Gacha",
        Description = "Tương tác Zioles → Spooky Gacha; chỉ ghi nhận thành công khi Candy giảm đủ 500. Script tự đếm lượt nó thực hiện; Gacha thường dùng chung cooldown do server kiểm soát.",
        Default = false,
        Callback = function(v)
                State.Gacha = v
                if v then
                        task.spawn(gachaLoop)
                        notify("Spooky Gacha", "Đã BẬT auto gacha!", "success")
                else
                        MZ_Tween.cancel("gacha")
                        notify("Spooky Gacha", "Đã TẮT.", "warning")
                end
        end,
})

SecDoor:CreateToggle({
        Title = "Tự đánh quái spawn khi gõ cửa",
        Description = "Gõ cửa spawn quái → bay TRÊN ĐẦU quái (BCH style) + fast attack. (Mặc định BẬT)",
        Default = true,
        Callback = function(v)
                State.AutoAttackMobs = v
                notify("Auto Attack Mobs", v and "Đã BẬT." or "Đã TẮT.", v and "success" or "warning")
        end,
})

SecDoor:CreateInput({
        Title = "Từ khóa cửa (phân cách bằng ,)",
        Placeholder = "knock,door,trick,treat,house",
        Default = State.KnockKeywords,
        Callback = function(text)
                State.KnockKeywords = text or ""
        end,
})

SecDoor:CreateSlider({
        Title = "Bán kính quét cửa",
        Min = 100, Max = 50000, Default = State.KnockRadius, Rounding = 0, Suffix = " studs",
        Callback = function(v)
                State.KnockRadius = v
        end,
})

SecDoor:CreateSlider({
        Title = "Thời gian khóa nhà locked",
        Description = "Phát hiện nhà locked → khóa NGUYÊN CĂN NHÀ (không phải từng cửa) trong X giây rồi mới thử lại.",
        Min = 60, Max = 600, Default = State.LockedDoorTime, Rounding = 0, Suffix = " giây",
        Callback = function(v)
                State.LockedDoorTime = v
        end,
})

SecDoor:CreateButton({
        Title = "Chẩn đoán Cửa + Thoại (in console)",
        Description = "In danh sách prompt cửa + GUI đang hiện ra console — gửi cho dev nếu gõ cửa / bấm Tiếp tục không hoạt động.",
        Callback = function()
                diagnoseEvent()
                notify("Chẩn đoán", "Đã in ra console — xem console của executor.", "info")
        end,
})

-- ── GREAT PUMPKIN BOSS ──
local SecGP = TabEvent:CreateSection("🔥 Great Pumpkin Boss")
local GreatPumpkinPrevious = nil

SecGP:CreateToggle({
        Title = "Auto Great Pumpkin",
        Description = "Farm các Pumpkin được nhận diện và nhặt drop; Auto Snowman chỉ đánh boss đã xuất hiện trong workspace.Enemies. Cơ chế phát hiện/đánh thức cụm 3 Pumpkin chưa được xác minh runtime. Khi đủ 200 Bits + 3 Seeds, bật Auto Summon để chọn Witch.",
        Default = false,
        Callback = function(v)
                State.AutoGreatPumpkin = v
                if v then
                        GreatPumpkinPrevious = {
                                farm = State.FarmPumpkin,
                                pickup = State.PickupDrops,
                                snowman = State.AutoSnowman,
                                farmOnly = State.FarmOnlyPumpkins,
                                pickupKeywords = State.PickupKeywords,
                        }
                        State.FarmOnlyPumpkins = true
                        State.PickupDrops = true
                        State.PickupKeywords = "candy,corn,pumpkin,bit,seed,cursed,spooky,treat"
                        State.FarmPumpkin = true
                        State.AutoSnowman = true
                        task.spawn(farmLoop)
                        task.spawn(pickupLoop)
                        task.spawn(bossLoop)
                        notify("Great Pumpkin", "Đã BẬT: farm Pumpkin lấy Bits + săn Pumpkin Snowman lấy Seeds + theo dõi Great Pumpkin.", "success")
                else
                        local prev = GreatPumpkinPrevious or {}
                        State.FarmOnlyPumpkins = prev.farmOnly or false
                        State.AutoSnowman = prev.snowman or false
                        State.PickupKeywords = prev.pickupKeywords or State.PickupKeywords
                        MZ_World.sig = "" -- buộc refresh cache với bộ từ khóa vừa khôi phục
                        if prev.farm then
                                State.FarmPumpkin = true
                                task.spawn(farmLoop) -- loop cũ đã nhường generation cho Great Pumpkin
                        else
                                State.FarmPumpkin = false
                                MZ_Tween.cancel("farm")
                        end
                        if prev.pickup then
                                State.PickupDrops = true
                                task.spawn(pickupLoop) -- loop cũ đã nhường generation
                        else
                                State.PickupDrops = false
                        end
                        if State.AutoSnowman or State.AutoSummon or State.AutoHellfire or State.AutoWerewolf then
                                task.spawn(bossLoop)
                        else
                                MZ_Tween.cancel("boss")
                        end
                        GreatPumpkinPrevious = nil
                        notify("Great Pumpkin", "Đã TẮT chế độ farm tổng hợp.", "warning")
                end
        end,
})

SecGP:CreateToggle({
        Title = "Auto Summon Great Pumpkin",
        Description = "Đến Witch và chọn đúng mục I want to fight the Great Pumpkin. Cần 3 Cursed Pumpkin Seeds + 200 Pumpkin Bits.",
        Default = false,
        Callback = function(v)
                State.AutoSummon = v
                if v then
                        task.spawn(bossLoop)
                        notify("Auto Summon Great Pumpkin", "Đã bật. Chỉ chọn Witch khi xác minh 200 Pumpkin Bits + 3 Cursed Pumpkin Seeds.", "success")
                else
                        if not (State.AutoGreatPumpkin or State.AutoSnowman
                                or State.AutoHellfire or State.AutoWerewolf) then
                                MZ_Tween.cancel("boss")
                        end
                        notify("Auto Summon Great Pumpkin", "Đã TẮT.", "warning")
                end
        end,
})

SecGP:CreateToggle({
        Title = "Ignore Jack o' Lantern",
        Description = "Không đánh quái Jack o' Lantern (spawn từ bí ngô / cửa).",
        Default = false,
        Callback = function(v)
                State.IgnoreJackOLantern = v
                notify("Ignore Jack o' Lantern", v and "Đã BẬT — bỏ qua." or "Đã TẮT — đánh bình thường.", "info")
        end,
})

SecGP:CreateToggle({
        Title = "Ignore Pumpkin Snowman",
        Description = "Không đánh Pumpkin Snowman (chúng chậm, ít reward).",
        Default = false,
        Callback = function(v)
                State.IgnorePumpkinSnowman = v
                notify("Ignore Snowman", v and "Đã BẬT — bỏ qua." or "Đã TẮT.", "info")
        end,
})

SecGP:CreateToggle({
        Title = "Break Rare Pumpkin Only",
        Description = "Chỉ đập bí ngô HIẾM (Rare Pumpkin — reward lớn hơn nhiều).",
        Default = false,
        Callback = function(v)
                State.BreakRareOnly = v
                notify("Rare Only", v and "Đã BẬT — chỉ đập bí ngô hiếm." or "Đã TẮT.", "info")
        end,
})

SecGP:CreateToggle({
        Title = "Ưu tiên đánh quái spawn",
        Description = "Đang đập bí ngô mà quái spawn → bay trên đầu quái đánh TRƯỚC rồi về đập tiếp. (Mặc định BẬT)",
        Default = true,
        Callback = function(v)
                State.EnemyPriority = v
                notify("Enemy Priority", v and "Đã BẬT." or "Đã TẮT.", "info")
        end,
})

-- ── BOSS EVENT ──
local SecBoss = TabEvent:CreateSection("💀 Boss Event")

SecBoss:CreateToggle({
        Title = "Auto Hellfire Gas 🔥",
        Description = "Đánh Hellfire Gas nếu boss đã xuất hiện trong workspace.Enemies. Không tự chọn Flaming Door/minigame khi chưa xác minh UI event.",
        Default = false,
        Callback = function(v)
                State.AutoHellfire = v
                if v then
                        task.spawn(bossLoop)
                        notify("Hellfire Gas", "Đã BẬT — auto đánh boss!", "success")
                else
                        notify("Hellfire Gas", "Đã TẮT.", "warning")
                end
        end,
})

SecBoss:CreateToggle({
        Title = "Auto Werewolf 🐺",
        Description = "Tự tìm + đánh boss Werewolf (bay trên đầu + fast attack BCH style).",
        Default = false,
        Callback = function(v)
                State.AutoWerewolf = v
                if v then
                        task.spawn(bossLoop)
                        notify("Werewolf", "Đã BẬT — auto đánh boss!", "success")
                else
                        notify("Werewolf", "Đã TẮT.", "warning")
                end
        end,
})

SecBoss:CreateToggle({
        Title = "Auto Pumpkin Snowman ⛄",
        Description = "Tìm và đánh Pumpkin Snowman đã xuất hiện trong workspace.Enemies. Việc nhận diện cụm 3 Pumpkin trước khi Snowman spawn vẫn phụ thuộc cấu trúc map runtime.",
        Default = false,
        Callback = function(v)
                State.AutoSnowman = v
                if v then
                        task.spawn(bossLoop)
                        notify("Pumpkin Snowman", "Đã BẬT — auto đánh!", "success")
                else
                        notify("Pumpkin Snowman", "Đã TẮT.", "warning")
                end
        end,
})

SecBoss:CreateInput({
        Title = "Từ khóa gacha (phân cách bằng ,)",
        Placeholder = "zioles,spooky,gacha,halloween",
        Default = State.GachaKeywords,
        Callback = function(text)
                State.GachaKeywords = text or ""
        end,
})

SecBoss:CreateSlider({
        Title = "Giá 1 lượt gacha (Candy)",
        Description = "Script TỰ TẮT gacha khi Candy dưới mức này (mặc định 500 như event).",
        Min = 100, Max = 5000, Default = State.GachaPrice, Rounding = 0, Suffix = " Candy",
        Callback = function(v)
                State.GachaPrice = v
        end,
})

SecBoss:CreateSlider({
        Title = "Nghỉ giữa 2 lượt roll",
        Min = 2, Max = 15, Default = State.GachaDelay, Rounding = 0, Suffix = " giây",
        Callback = function(v)
                State.GachaDelay = v
        end,
})

SecBoss:CreateSlider({
        Title = "Số roll tối đa (0 = không giới hạn)",
        Min = 0, Max = 50, Default = State.GachaMaxRolls, Rounding = 0, Suffix = " lượt",
        Callback = function(v)
                State.GachaMaxRolls = v
        end,
})

-- ── MYSTERY HALL ──
local SecHall = TabEvent:CreateSection("🏚️ Mystery Hall")

SecHall:CreateToggle({
        Title = "Theo dõi Monster Chase (hành lang Oni)",
        Description = "Theo dõi giao diện Monster Chase/Numbered Hallway. Script chưa tự quan sát vị trí Oni và chưa tự chọn đáp án 6 phòng.",
        Default = false,
        Callback = function(v)
                State.MysteryHall = v
                if v then
                        task.spawn(mysteryHallLoop)
                        notify("Monster Chase", "Đã bật theo dõi UI. Script không tự đoán đáp án 6 phòng.", "info")
                else
                        MZ_Tween.cancel("hall")
                        notify("Mystery Hall", "Đã TẮT.", "warning")
                end
        end,
})

-- ════════════════════════════ 20. TAB: KHÁC ═══════════════════════════════
local TabMisc = Window:CreateTab("Khác")

-- ── Anti-Ban / Anti-Cheat (mượn + cải thiện từ Banana Cat Hub) ──
local SecAntiBan = TabMisc:CreateSection("🛡️ Anti-Ban / Anti-Cheat")

SecAntiBan:CreateParagraph({
        Title = "Streaming / Identity (thử nghiệm, không chống ban)",
        Content = "• Một số executor có API nâng thread identity / SimulationRadius; game có thể từ chối thay đổi này.\n"
                .. "• Anti-Kick chỉ chặn một lời gọi Kick phía client khi hook hoạt động; không chặn server kick/ban.\n"
                .. "• Tween và giới hạn tốc độ không bảo đảm tránh phát hiện hoặc xử phạt.\n"
                .. "• Anti-AFK chỉ mô phỏng input idle, không bảo đảm không bị kick.\n"
                .. "Không có toggle nào trong đây bảo đảm an toàn tài khoản; server vẫn có toàn quyền kiểm tra.",
})

SecAntiBan:CreateToggle({
        Title = "Streaming / Identity (experimental)",
        Description = "Thử thay đổi streaming/identity nếu executor cho phép; không có khả năng bảo đảm chống ban.",
        Default = false,
        Callback = function(v)
                State.AntiBan = v
                if v then
                        ElevateIdentity()
                        applyStreamingFix()
                        notify("Streaming / Identity", "Đã thử áp dụng. Có thể bị game/executor từ chối; không bảo đảm chống ban.", "warning")
                else
                        restoreStreamingFix()
                        notify("Streaming / Identity", "Đã tắt và thử khôi phục streaming ban đầu; game có thể từ chối thay đổi.", "warning")
                end
        end,
})

SecAntiBan:CreateToggle({
        Title = "Anti-Kick (chặn :Kick) — chỉ bật khi cần",
        Description = "Hook __namecall chặn LocalPlayer:Kick(). MẶC ĐỊNH TẮT — chỉ bật nếu bị kick, vì hook có thể bị anticheat phát hiện.",
        Default = false,
        Callback = function(v)
                State.AntiKick = v
                if v then
                        installAntiKick()
                        notify("Anti-Kick", "Đã BẬT chặn :Kick().", "success")
                else
                        notify("Anti-Kick", "Đã TẮT — lưu ý: hook đã cài không thể gỡ an toàn, chỉ tắt cờ.", "warning")
                end
        end,
})

SecAntiBan:CreateToggle({
        Title = "Anti-AFK",
        Description = "Chống bị kick khi để farm lâu",
        Default = true,
        Callback = function(v)
                State.AntiAFK = v
                notify("Anti-AFK", v and "Đã BẬT." or "Đã TẮT.", v and "success" or "warning")
        end,
})

local SecMisc = TabMisc:CreateSection("Tiện Ích")

SecMisc:CreateToggle({
        Title = "Giảm Lag (Tắt FX an toàn)",
        Description = "Tắt particle/lửa/khói/đèn hiệu ứng — KHÔNG đụng Beam/Trail để không lỗi game",
        Default = false,
        Callback = function(v)
                State.NoFX = v
                pcall(function() setNoFX(v) end)
                notify("Giảm Lag", v and "Đã tắt FX an toàn." or "Đã bật lại FX.", v and "success" or "info")
        end,
})

SecMisc:CreateParagraph({
        Title = "🛠️ Về lỗi console trong game",
        Content = "Các lỗi 'PartType', 'Jack o' Lantern parent locked', 'VehicleSeat',\n"
                .. "'active dialogue', 'CChain out of radius'... đều là LỖI CỦA GAME\n"
                .. "(combat module / NPCStreaming / ShipController), KHÔNG phải script.\n"
                .. "Chúng KHÔNG ảnh hưởng farm.\n\n"
                .. "⚠ Script KHÔNG hook `warn` để ẩn (v2.6 từng hook → bị văng game\n"
                .. "do hookfunction đệ quy vô hạn). Dùng filter console của executor\n"
                .. "nếu muốn ẩn. Hook `error` sẽ phá game nên không làm.",
})

SecMisc:CreateToggle({
        Title = "Watermark FPS/Ping (Meizu Extras)",
        Default = false,
        Callback = function(v)
                pcall(function()
                        local Extras = getgenv().MeizuExtras
                        if Extras then
                                if v then
                                        Extras:EnableWatermark({ ShowFPS = true, ShowPing = true })
                                else
                                        Extras:DisableWatermark()
                                end
                        end
                end)
        end,
})

SecMisc:CreateButton({
        Title = "Hop Server (random)",
        Description = "Tìm server khác để có nhiều bí ngô mới",
        Callback = function()
                task.spawn(hopServer)
        end,
})

SecMisc:CreateButton({
        Title = "Rejoin Server",
        Callback = function()
                notify("Rejoin", "Đang vào lại server...", "info")
                task.wait(0.4)
                pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end)
        end,
})

SecMisc:CreateButton({
        Title = "Gỡ Script (Unload)",
        Description = "Tắt mọi tính năng + xóa UI",
        Callback = function()
                if getgenv().MZ_Halloween_Unload then
                        getgenv().MZ_Halloween_Unload()
                end
        end,
})

SecMisc:CreateParagraph({
        Title = "ℹ️ Credits",
        Content = "Meizu Library & Hub — Nttp1721\n"
                .. "Tham khảo kỹ thuật: Banana Cat Hub (meizublf.lua)\n"
                .. "ESP Pumpkin gốc: FixedPumpkinESP của bạn",
})
end -- /buildUI()
buildUI() -- xay dung UI (16 local trong scope rieng, khong anh huong main chunk)

-- ════════════════════════════ 21. VÒNG LẶP TRẠNG THÁI ════════════════════
task.spawn(function()
        while not Unloaded do
                pcall(function()
                        if statusPara and statusPara.SetContent then
                                refreshPumpkins() -- đọc từ cache chung (giảm lag)
                                local itemStatus = ""
                                if State.AutoGreatPumpkin or State.AutoSummon then
                                        local bits, seeds = readGreatPumpkinRequirements()
                                        if bits ~= nil and seeds ~= nil then
                                                itemStatus = string.format("\n🎃 Pumpkin Bits: %d/200   |   🌱 Cursed Seeds: %d/3", bits, seeds)
                                        else
                                                itemStatus = "\n🎃 Không đọc được số Bits/Seeds từ Inventory runtime."
                                        end
                                end
                                statusPara:SetContent(string.format(
                                        "🎃 Bí ngô trong map: %d   |   📍 PumpkinPatch: %d\n🎯 Trạng thái: %s%s",
                                        #MZ_World.pumpkins, #MZ_World.patches, State.StatusText or "Tắt", itemStatus
                                ))
                        end
                end)
                task.wait(2)
        end
end)

-- ════════════════════════════ 22. UNLOAD (SẠCH — v5.1) ════════════════════
getgenv().MZ_Halloween_Unload = function()
        if Unloaded then return end
        Unloaded = true
        State.Noclip = false
        State.FarmPumpkin = false
        State.ESP = false
        State.ESPPatch = false
        State.TrickOrTreat = false
        State.Gacha = false
        State.PickupDrops = false
        State.AutoBuso = false
        State.NoFX = false
        State.AntiBan = false
        State.AntiKick = false
        -- v5.0 event
        State.AutoHellfire = false
        State.AutoWerewolf = false
        State.AutoSnowman = false
        State.AutoGreatPumpkin = false
        State.AutoSummon = false
        State.AutoAttackMobs = false
        State.MysteryHall = false
        State.FarmOnlyPumpkins = false
        MZ_Tween.cancel()
        espClearAll()
        -- ═══ v5.1: DỌN SẠCH TRẠNG THÁI VẬT LÝ ═══
        --   • Xóa FloatForce còn sót → hết bị "đứng freeze trên không" tới respawn
        --   • KHÔI PHỤC collision (noclip tắt triệt để)
        --   • Nhả quyền di chuyển + dọn cache cửa/nhà
        do
                local root = getRoot()
                if root then
                        local ff = root:FindFirstChild("MZ_FloatForce")
                        if ff then pcall(function() ff:Destroy() end) end
                end
        end
        restoreCollisions()
        restoreStreamingFix()
        pcall(function() setNoFX(false) end)
        MoveBus.owner = nil
        MoveBus.thread = nil
        MoveBus.since = 0
        houseState = {}
        doorCooldown = {}
        DialogueLog = {}
        for _, c in ipairs(Connections) do
                pcall(function() c:Disconnect() end)
        end
        Connections = {}
        pcall(function() Library:Destroy() end)
        getgenv().MZ_Halloween_Unload = nil
        print("[MZ Halloween] Đã gỡ script — đã khôi phục collision + xóa FloatForce.")
end

-- ════════════════════════════ 23. KHỞI ĐỘNG ═══════════════════════════════
Window:SelectTab(1)
refreshPumpkins(true)
if State.AutoBuso then
        task.spawn(busoLoop) -- Buso mặc định BẬT → tự kích hoạt ngay từ khi nạp
end
if State.PickupDrops then
        task.spawn(pickupLoop) -- Auto Pickup mặc định BẬT → không cần đợi bật farm
end
notify("Meizu Hub 🎃", "Đã nạp Halloween Event 2026 v5.2 FIXED!\nState machine: ToT bấm thoại + Boss + Gacha + Mystery Hall.", "success")
print("[MZ Halloween] Loaded — Meizu Hub Halloween 2026 v5.2 FIXED (dialog engine 4 lớp + khóa theo nhà + spawn-diff quái cửa + boss state machine + gacha full cycle + mystery hall + move bus + unload restore) | Library: Meizu v3.1")
