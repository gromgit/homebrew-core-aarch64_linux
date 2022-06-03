class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.1.tar.gz"
  sha256 "bbc61706bdcbeb4c38f1b5030a9ad4a1149290168c59215e52094035c4519d11"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ee579f202d33b6b5c168d5f398f9c770c14af71022a8304fb8886c8b6b0a45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27e6387a690a793c2d10e5a1748d7f03391e08c9d98460c7530bd78d97460bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "17a462b112d93329eef45d9a261f53190412f600daa12f421ceb0f0e628dbf8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "90d5852f8ca3629a6cab02e79a41da1f7be433aad4209dd9e286e29d8160b281"
    sha256 cellar: :any_skip_relocation, catalina:       "b213af559da69bd79a2376c47469c65eba1faa06b167b999f4c3f3f5282a404c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a69614067a52661db61443a928292377dd941cc48ea7fe12cfb21ccadbdcaf6"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    (bash_completion/"atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (fish_completion/"atlas.fish").write Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (zsh_completion/"_atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
