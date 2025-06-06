# AVD構成・管理のアプローチ

以下の2つのアプローチ
参考：[Azure Virtual Desktop のホスト プール管理アプローチ](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/host-pool-management-approaches#session-host-configuration)

## [1. 標準管理アプローチ（Standard Management）](./AVD_Standard_Procedure.md)

- 概要
  - 従来の方法。管理者がセッションホストの作成・更新・スケーリングを自分で管理。
- 特徴
  - PowerShell、ARMテンプレート、Terraformなどのツールを自由に使用可能。
  - カスタムスクリプトやCI/CDパイプラインとの統合が可能。
- メリット
  - 高い柔軟性。
  - 既存の運用プロセスに組み込みやすい。
- デメリット
  - 自動化や一貫性の確保には工夫が必要。
  - 手動作業やスクリプトの保守が発生。

## [2. セッション ホスト構成アプローチ（Session Host Configuration）※プレビュー](./AVD_SessionConfig.md)

- 概要
  - AVDがネイティブに提供する新しい管理モデル。ホストプールに対して「構成テンプレート」を定義し、それに基づいてセッションホストを自動的に作成・更新。
- 構成要素
  - セッション ホスト構成: VMサイズ、OS、ドメイン参加、ネットワークなどのテンプレート。
  - セッション ホスト管理ポリシー: 更新タイミングや通知方法などのポリシー。
  - セッション ホスト更新: 構成変更を既存ホストに反映する仕組み。
  - 自動スケーリング: スケジュールや負荷に応じた動的スケーリング。
- メリット
  - 一貫性のある構成管理。
  - GUIベースで簡単に設定可能。
  - スケーリングや更新が自動化されている。
- デメリット
  - 現時点ではプレビュー機能。
  - Microsoft Entra ID Join（Azure AD Join）には未対応（Hybrid Joinは可）。
  - 標準管理用のツールとの併用は不可。

## 比較まとめ
項目	|標準管理	|セッション ホスト構成
-|-|-|
自動化	|スクリプトや外部ツールで対応	|AVDネイティブで対応
柔軟性  |高い（自由に構成可能）	|テンプレートベースで制限あり
一貫性	|手動で担保	|自動で担保
スケーリング|自前で構築|ネイティブに対応
運用負荷	|高め	|低め（GUI中心）
対応状況	|一般提供	|プレビュー（制限あり）

## セッション ホスト構成と標準管理の比較
| シナリオまたは機能 | セッション ホストの構成 | 標準管理 |
| --- | --- | --- |
| セッション ホストを作成する | Azure portal を使い、セッション ホスト構成に基づいて、[セッション ホストを追加します](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/add-session-hosts-host-pool?pivots=host-pool-session-host-configuration)。 Azure Virtual Desktop の外部で作成されたセッション ホストをホスト プールに追加するために登録トークンを取得することはできません。 | 任意の方法を使って[セッション ホストを追加](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/add-session-hosts-host-pool?pivots=host-pool-standard)した後、登録トークンを使ってホスト プールに追加します。 Azure portal を使う場合は、毎回構成を入力する必要があります。 |
| セッション ホストを構成する | セッション ホスト構成により、一貫したセッション ホストの構成が保証されます。 | ホスト プール内のセッション ホストの構成の一貫性は、ユーザーが保証する必要があります。 セッション ホスト構成は使用できません。 |
| セッション ホストをスケーリングする | [自動スケーリング](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/autoscale-scenarios)を使用し、スケジュールと使用状況に基づいて、セッション ホストのオンとオフの切り替え、作成、削除を行います。 | [自動スケーリング](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/autoscale-scenarios)を使い、スケジュールと使用状況に基づいて、セッション ホストのオンとオフを切り替えます。 |
| セッション ホストのイメージを更新する | [セッション ホスト更新](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/session-host-update)を使い、セッション ホスト管理ポリシーとセッション ホスト構成に基づいて、セッション ホストのイメージと構成を更新します。 | 自動パイプラインやカスタム スクリプトなど、ユーザー独自の既存のツールとプロセスを使って、セッション ホストのイメージと構成を更新します。 セッション ホスト更新を使うことはできません。 |
| セッション ホストの電源を自動的にオンにする | エンド ユーザーが必要な時にだけセッション ホストをオンにできるようにするには、[Start VM on Connect](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/start-virtual-machine-connect) を使います。 | エンド ユーザーが必要な時にだけセッション ホストをオンにできるようにするには、[Start VM on Connect](https://learn.microsoft.com/ja-jp/azure/virtual-desktop/start-virtual-machine-connect) を使います |