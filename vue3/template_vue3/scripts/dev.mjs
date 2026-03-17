import { execSync, spawn } from "node:child_process";
import os from "node:os";

const PORT = 5173;
const HOST = "127.0.0.1";

function listPidsOnWindows(port) {
    try {
        const output = execSync(`netstat -ano -p tcp | findstr :${port}`, {
            encoding: "utf-8",
            stdio: ["ignore", "pipe", "ignore"]
        });
        return output
            .split(/\r?\n/)
            .map((line) => line.trim())
            .filter(Boolean)
            .filter((line) => line.includes(`:${port}`))
            .map((line) => Number(line.split(/\s+/).at(-1)))
            .filter((pid) => Number.isFinite(pid) && pid > 0);
    } catch {
        return [];
    }
}

function listPidsOnUnix(port) {
    try {
        const output = execSync(`lsof -ti tcp:${port}`, {
            encoding: "utf-8",
            stdio: ["ignore", "pipe", "ignore"]
        });
        return output
            .split(/\r?\n/)
            .map((line) => Number(line.trim()))
            .filter((pid) => Number.isFinite(pid) && pid > 0);
    } catch {
        return [];
    }
}

function killPortListeners(port, exceptPid) {
    const pids = os.platform() === "win32" ? listPidsOnWindows(port) : listPidsOnUnix(port);
    for (const pid of [...new Set(pids)]) {
        if (exceptPid && pid === exceptPid) continue;
        try {
            if (os.platform() === "win32") {
                execSync(`taskkill /PID ${pid} /F`, { stdio: "ignore" });
            } else {
                process.kill(pid, "SIGKILL");
            }
            console.log(`[dev] Released port ${port} by killing PID ${pid}`);
        } catch {
            // ignore
        }
    }
}

killPortListeners(PORT);

const isWin = os.platform() === "win32";
const npxCommand = isWin ? "npx.cmd" : "npx";

const child = spawn(
    npxCommand,
    ["vite", "--host", HOST, "--port", String(PORT), "--strictPort"],
    {
        stdio: "inherit",
        shell: isWin
    }
);

let shuttingDown = false;
function shutdown(signal) {
    if (shuttingDown) return;
    shuttingDown = true;
    try {
        child.kill(signal ?? "SIGTERM");
    } catch {
        // ignore
    }
    setTimeout(() => {
        killPortListeners(PORT, process.pid);
        process.exit(0);
    }, 300);
}

process.on("SIGINT", () => shutdown("SIGINT"));
process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("exit", () => killPortListeners(PORT, process.pid));

child.on("error", (err) => {
    console.error("[dev] Failed to start vite:", err);
    process.exit(1);
});

child.on("exit", (code) => {
    killPortListeners(PORT, process.pid);
    process.exit(code ?? 0);
});