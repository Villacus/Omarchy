// Script Complete Discord Quest
// Fuente: https://gist.github.com/CiszukoAntony/0f0932214e8975dfc874a528a73eebd5
// Pegar en Consola de Discord (Ctrl+Shift+I) despues de escribir "allow pasting"

delete window.$;
window.stopQuestScript = false;
let wpRequire = webpackChunkdiscord_app.push([[Symbol()], {}, r => r]);
webpackChunkdiscord_app.pop();

function getStore(findFn, fallback = null) {
  try {
    return Object.values(wpRequire.c).find(findFn);
  } catch (e) {
    console.warn('Store no encontrado:', e);
    return fallback;
  }
}

let ApplicationStreamingStore = getStore(x => x?.exports?.A?.__proto__?.getStreamerActiveStreamMetadata)?.exports?.A;
let RunningGameStore = getStore(x => x?.exports?.Ay?.getRunningGames)?.exports?.Ay;
let QuestsStore = getStore(x => x?.exports?.A?.__proto__?.getQuest)?.exports?.A;
let ChannelStore = getStore(x => x?.exports?.A?.__proto__?.getAllThreadsForParent)?.exports?.A;
let GuildChannelStore = getStore(x => x?.exports?.Ay?.getSFWDefaultChannel)?.exports?.Ay;
let FluxDispatcher = getStore(x => x?.exports?.h?.__proto__?.flushWaitQueue)?.exports?.h;
let api = getStore(x => x?.exports?.Bo?.get)?.exports?.Bo;

if (!QuestsStore || !ChannelStore || !GuildChannelStore || !FluxDispatcher || !api) {
  console.error('No se pudieron obtener los stores necesarios. El script no puede continuar.');
} else {
  const supportedTasks = ["WATCH_VIDEO", "PLAY_ON_DESKTOP", "STREAM_ON_DESKTOP", "PLAY_ACTIVITY", "WATCH_VIDEO_ON_MOBILE"];
  let quests = [];
  try {
    quests = [...QuestsStore.quests.values()].filter(x => x.userStatus?.enrolledAt && !x.userStatus?.completedAt && new Date(x.config.expiresAt).getTime() > Date.now() && supportedTasks.find(y => Object.keys((x.config.taskConfig ?? x.config.taskConfigV2).tasks).includes(y)));
  } catch (e) {
    console.error('Error obteniendo quests:', e);
  }
  
  let isApp = typeof DiscordNative !== "undefined";
  if (quests.length === 0) {
    console.log("¡No tienes quests incompletas!");
  } else {
    let doJob = function() {
      if (window.stopQuestScript) { console.log("Script detenido."); return; }
      const quest = quests.pop();
      if (!quest) return;
      
      const pid = Math.floor(Math.random() * 30000) + 1000;
      
      const questName = quest.config.messages.questName;
      const taskConfig = quest.config.taskConfig ?? quest.config.taskConfigV2;
      const taskName = supportedTasks.find(x => taskConfig.tasks && taskConfig.tasks[x] != null);
      const taskData = taskConfig.tasks[taskName];
      const applicationId = quest.config.application?.id ?? taskData.applications?.[0]?.id;
      const secondsNeeded = taskData.target;
      let secondsDone = quest.userStatus?.progress?.[taskName]?.value ?? 0;
      
      if (taskName === "WATCH_VIDEO" || taskName === "WATCH_VIDEO_ON_MOBILE") {
        const maxFuture = 10, speed = 7, interval = 1;
        const enrolledAt = new Date(quest.userStatus.enrolledAt).getTime();
        let completed = false;
        let fn = async () => {
          while (true) {
            if (window.stopQuestScript) return;
            const maxAllowed = Math.floor((Date.now() - enrolledAt) / 1000) + maxFuture;
            const diff = maxAllowed - secondsDone;
            const timestamp = secondsDone + speed;
            if (diff >= speed) {
              const res = await api.post({url: `/quests/${quest.id}/video-progress`, body: {timestamp: Math.min(secondsNeeded, timestamp + Math.random())}});
              completed = res.body.completed_at != null;
              secondsDone = Math.min(secondsNeeded, timestamp);
            }
            if (timestamp >= secondsNeeded) break;
            await new Promise(resolve => setTimeout(resolve, interval * 1000));
          }
          if (!completed) await api.post({url: `/quests/${quest.id}/video-progress`, body: {timestamp: secondsNeeded}});
          console.log("¡Quest completada!");
          doJob();
        };
        fn();
        console.log(`Falsificando video para ${questName}.`);
      } else if (taskName === "PLAY_ON_DESKTOP") {
        if (!isApp) { console.log("Usa la app de escritorio."); return; }
        api.get({url: `/applications/public?application_ids=${applicationId}`}).then(res => {
          const appData = res.body[0];
          let exeName = appData.name;
          if (appData.executables && Array.isArray(appData.executables)) {
            const exeWin = appData.executables.find(x => x.os === "win32");
            if (exeWin) exeName = exeWin.name.replace(/>/g, "");
          }
          const fakeGame = {
            cmdLine: `C:\\Program Files\\${appData.name}\\${exeName}`,
            exeName, exePath: `c:/program files/${appData.name.toLowerCase()}/${exeName}`,
            hidden: false, isLauncher: false, id: applicationId, name: appData.name,
            pid: pid, pidPath: [pid], processName: appData.name, start: Date.now(),
          };
          const realGames = RunningGameStore.getRunningGames();
          const realGetRunningGames = RunningGameStore.getRunningGames;
          const realGetGameForPID = RunningGameStore.getGameForPID;
          RunningGameStore.getRunningGames = () => [fakeGame];
          RunningGameStore.getGameForPID = (pid) => fakeGame;
          FluxDispatcher.dispatch({type: "RUNNING_GAMES_CHANGE", removed: realGames, added: [fakeGame], games: [fakeGame]});
          let fn = data => {
            let progress = quest.config.configVersion === 1 ? data.userStatus.streamProgressSeconds : Math.floor(data.userStatus.progress.PLAY_ON_DESKTOP.value);
            console.log(`Progreso: ${progress}/${secondsNeeded}`);
            if (progress >= secondsNeeded) {
              RunningGameStore.getRunningGames = realGetRunningGames;
              RunningGameStore.getGameForPID = realGetGameForPID;
              FluxDispatcher.dispatch({type: "RUNNING_GAMES_CHANGE", removed: [fakeGame], added: [], games: []});
              FluxDispatcher.unsubscribe("QUESTS_SEND_HEARTBEAT_SUCCESS", fn);
              doJob();
            }
          };
          FluxDispatcher.subscribe("QUESTS_SEND_HEARTBEAT_SUCCESS", fn);
          console.log(`Falsificado juego a ${questName}. Espera ${Math.ceil((secondsNeeded - secondsDone) / 60)} min.`);
        });
      } else if (taskName === "STREAM_ON_DESKTOP") {
        if (!isApp) { console.log("Usa la app de escritorio."); return; }
        let realFunc = ApplicationStreamingStore.getStreamerActiveStreamMetadata;
        ApplicationStreamingStore.getStreamerActiveStreamMetadata = () => ({id: applicationId, pid, sourceName: null});
        let fn = data => {
          let progress = quest.config.configVersion === 1 ? data.userStatus.streamProgressSeconds : Math.floor(data.userStatus.progress.STREAM_ON_DESKTOP.value);
          console.log(`Progreso: ${progress}/${secondsNeeded}`);
          if (progress >= secondsNeeded) {
            ApplicationStreamingStore.getStreamerActiveStreamMetadata = realFunc;
            FluxDispatcher.unsubscribe("QUESTS_SEND_HEARTBEAT_SUCCESS", fn);
            doJob();
          }
        };
        FluxDispatcher.subscribe("QUESTS_SEND_HEARTBEAT_SUCCESS", fn);
        console.log(`Falsificado stream. Stream en vc por ${Math.ceil((secondsNeeded - secondsDone) / 60)} min. Necesitas 1 persona mas en el vc.`);
      } else if (taskName === "PLAY_ACTIVITY") {
        let channelId = null;
        try {
          const privChannels = ChannelStore.getSortedPrivateChannels();
          if (privChannels?.length) { channelId = privChannels[0].id; }
          else {
            const guilds = Object.values(GuildChannelStore.getAllGuilds());
            const vocalGuild = guilds.find(x => x?.VOCAL?.length);
            if (vocalGuild) channelId = vocalGuild.VOCAL[0].channel.id;
          }
        } catch (e) { console.error(e); }
        if (!channelId) { console.error("No channelId"); return; }
        const streamKey = `call:${channelId}:1`;
        let fn = async () => {
          while (true) {
            if (window.stopQuestScript) return;
            const res = await api.post({url: `/quests/${quest.id}/heartbeat`, body: {stream_key: streamKey, terminal: false}});
            const progress = res.body.progress.PLAY_ACTIVITY.value;
            console.log(`Progreso: ${progress}/${secondsNeeded}`);
            await new Promise(resolve => setTimeout(resolve, 20 * 1000));
            if (progress >= secondsNeeded) {
              await api.post({url: `/quests/${quest.id}/heartbeat`, body: {stream_key: streamKey, terminal: true}});
              break;
            }
          }
          console.log("¡Quest completada!");
          doJob();
        };
        fn();
      }
    };
    doJob();
  }
}
