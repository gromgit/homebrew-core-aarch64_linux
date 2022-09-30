class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.19.2.tar.gz"
  sha256 "3ebf2247c9c6063745a9c4db0867681073350366e4c620d2fb084dd82b722ee5"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "475a33a464317145f28c3d7c5897945cca1fe0bc98cd13bf2996af46822ddf6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfcbe69a214225d2895ab031152c25674f0b301dda2ecffda9f16b2149487108"
    sha256 cellar: :any_skip_relocation, monterey:       "85886b41ef75f783a8f298b918ca2df48ec16aa68e43aea196e3867b96fb8a5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e6acb6806967369cbdff70c3dd1f0113b708417d7d31cf5e84727f5115bf566"
    sha256 cellar: :any_skip_relocation, catalina:       "e8fec781ec17faf6a4467fdca6f19c4933d42075accb2f75043f662ceeb9a34e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6b5d2839b509900d2c9d435bff524f0518eedfa96ca9fea3c5a6ddbf33ee6e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
