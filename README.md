# docker-mirakc

テレビ録画用の [mirakc](https://github.com/mirakc/mirakc) Docker イメージです。

## 含まれるコンポーネント

| コンポーネント | バージョン | 説明 |
|--------------|----------|------|
| [mirakc](https://github.com/mirakc/mirakc) | 3.4.63 | Mirakurun 互換チューナーサーバー |
| [recisdb-rs](https://github.com/kazuki0824/recisdb-rs) | 1.2.4 | B-CAS カードリーダー / TS ストリームデコーダー |
| [miraview](https://github.com/maeda577/miraview) | v0.1.2 | mirakc 向け Web UI |

## イメージ

GitHub Container Registry で公開しています:

```
ghcr.io/longkey1/mirakc:latest
ghcr.io/longkey1/mirakc:<mirakc-version>-latest
ghcr.io/longkey1/mirakc:<tag>
```

`<tag>` はリリースタグ（例: `3.4.63-1.2.4-v0.1.2`）です。

対応プラットフォーム: `linux/amd64`, `linux/arm64`

## 特徴

- コンテナ起動時に `pcscd`（PC/SC デーモン）を自動起動し、B-CAS カード読み取りに対応
- mirakc API エンドポイント（`/api/version`）によるヘルスチェック
- pcscd の polkit 認証を無効化済み

## バージョン管理

各コンポーネントのバージョンはリポジトリルートのバージョンファイルで管理しています:

| ファイル | 対象 |
|---------|------|
| `.mirakc-version` | mirakc ベースイメージのバージョン |
| `.recisdb-rs-version` | recisdb-rs のリリースバージョン |
| `.miraview-version` | miraview のリリースバージョン |

## 使い方

設定ファイルやデバイスファイルを必要に応じてマウントしてください:

```yaml
services:
  mirakc:
    image: ghcr.io/longkey1/mirakc:latest
    devices:
      - /dev/bus/usb:/dev/bus/usb
    volumes:
      - ./config.yml:/etc/mirakc/config.yml
    ports:
      - "40772:40772"
```

## ビルド

`*.*.*-*` パターンのタグプッシュをトリガーに、GitHub Actions で自動的にビルドして GHCR へ公開します。

タグのフォーマット例: `3.4.63-1.2.4-v0.1.2`（`<mirakc>-<recisdb-rs>-<miraview>`）
