class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.40.0.tar.gz"
  sha256 "d3e00387c6dda4e53b3816175b8772db53124198d8ceb499c9a1f6b76092df83"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5aa901b6799279240233a3802759037ad08786cf4bfba59cb407123c6f9dbd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4da4cc94490e029837639ffd7404c3f82a329c0c29f06c0ecfebdf565e859035"
    sha256 cellar: :any_skip_relocation, monterey:       "0af73399e671c09b4b502f468155751e7006e2c39c7a50a839df805be2bf7008"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d7c361576f044d1ffe5b43d4f483fdb51abbed520f0078e249ef71e1ebfee11"
    sha256 cellar: :any_skip_relocation, catalina:       "bc0cc964798f085b4f780f4bd3b3ca7d8eacd7679295aee2e2e6897f653501a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd76fb0c13d2ab09ac0b5d9aeae1f00e51fe7cd41619836ffe5660443cac3f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
