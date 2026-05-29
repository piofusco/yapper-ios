#  Yapper iOS

## Setup ⚙️

### Generate the Project with Xcodegen

To get started, you’ll need to generate the `Yapper.xcodeproj`. This repository uses [Xcodegen](https://github.com/yonaskolb/XcodeGen). You'll first need to install [Homebrew](https://brew.sh/), then install Xcodegen with the following command:

```bash
brew install xcodegen
```

Once installed, generate the Xcode project by running:

```bash
xcodegen generate
```

**Note**: You’ll need to run this command when:
1. Adding/removing a file.
2. Adding/removing a dependency.
3. Updating any part of the Xcode project.

This project uses **Xcode 26.5**.

## ⚛ Environments ⚛

Yapper supports the following environments, each with its associated bundle ID:

- **Development**: `com.piofusco.Yapper.debug`
- **Production**: `com.piofusco.Yapper`

The project uses compiler directives for each environment:

- `DEBUG`
- `RELEASE`

And corresponding schemes:

- `Yapper_dev`
- `Yapper_release` (prod)

# WebSocket Protocol

Endpoint: `ws://<host>:8222/ws`
Frame: text, one JSON object per frame, field `type` discriminates.
Auth: `type=auth` must succeed before any other command (else `error/not_authenticated`). Token obtained via `POST /login`.

## Client → Server

| type               | required fields                                     | notes |
| ------------------ | --------------------------------------------------- | ----- |
| `auth`             | `token: string`                                     | first frame; replaces any existing session for user |
| `ping`             | —                                                   | → `pong` |
| `msg`              | `room: string`, `text: string`                      | room must exist; no ack on success |
| `peers`            | `room: string`                                      | → `peers` |
| `signal`           | `to: string`, `payload: any`                        | WebRTC signaling relay; payload opaque |
| `create_party`     | —                                                   | → `party_joined` |
| `join_party`       | `party_id: string`                                  | → `party_joined` |
| `leave_party`      | `party_id: string`                                  | → `party_left` |
| `list_parties`     | —                                                   | → `parties` |
| `set_party_private`| `party_id: string`, `private: bool`                 | admin only; no ack |
| `invite_user`      | `party_id: string`, `username: string`              | no ack |
| `revoke_invite`    | `party_id: string`, `username: string`              | no ack |
| `accept_invite`    | `party_id: string`                                  | → `party_joined` |
| `decline_invite`   | `party_id: string`                                  | no ack |
| `dm`               | `to: string`, `text: string`                        | → `dm_sent`; queued if recipient offline |
| `join_screen`      | `room: string`                                      | → `screen_joined` |
| `leave_screen`     | `room: string`                                      | → `screen_left` |

## Server → Client

