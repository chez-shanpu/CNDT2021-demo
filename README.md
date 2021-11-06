# CNDT2021 demo
[CiliumによるKubernetes Network Policyの実現](https://event.cloudnativedays.jp/cndt2021/talks/1243) の発表で使用したファイル集です。

## セットアップ

```shell
# kindを使ったクラスタの立ち上げ、
# Cilium CLIのインストールおよびクラスタへのCiliumのデプロイ、
# デモで使用するDockerイメージのビルドとkind nodeへのロードを行います。
$ make

# kind clusterの削除を行います（後片付け用）。
$ make clean
```

## 各ディレクトリについて

- `Docker/`
  - デモで使用するDockerイメージ用のDockerfileとソースファイルがあります。
- `cluster/`
    - kind clusterの設定ファイルがあります。
- `demo1/`、`demo2/`
  - それぞれデモで使用したマニフェストファイルがあります。
