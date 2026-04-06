export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {

    const marioSounds = [
        "haha",
        "hello",
        "hoo",
        "let-s-go",
        "mama-mia",
        "okie-dokie",
        "wa-ha",
        "yoshi",
    ]

    const soundName = marioSounds[Math.floor(Math.random() * marioSounds.length)]

    return {
        event: async ({ event }) => {
            if (event.type === "session.idle") {
                const projectName = project.worktree.split("/").at(-1)
                // await $`osascript -e 'display notification "${projectName} session done" with title "Opencode" sound name "${soundName}"'`
                await $`osascript -e 'display notification "${projectName} session done" with title "Opencode"'`
                await $`open raycast://extensions/raycast/raycast/confetti`
            }
        },
    }
}
