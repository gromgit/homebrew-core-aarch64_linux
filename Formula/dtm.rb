class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "6a4154260a99c3717d1a11922181129cb11fc27ec2b645a7892d10fc1b58ad39"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b271db8a588763d41c760cc9fbdee4fb6b2364881a8ec1216c1d604ff8c0f3a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "391f6ed3c094374bf6393836845a98ff77983d98e046fe3ea527cfed17d0189a"
    sha256 cellar: :any_skip_relocation, monterey:       "7224704277a944ba445822fa35caaf27fbcbbce586fe73d873e83a709e371d11"
    sha256 cellar: :any_skip_relocation, big_sur:        "339eaa8686213f589e362b495858d86fdc8c95f44292e5517a8d014af4045a0b"
    sha256 cellar: :any_skip_relocation, catalina:       "328478098bff89a969ce82ac43ee6aa4b83768875120c21cff4c7cd351749acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7714f12b4513f1f46489459ab373961174941ef7f6fabe17a1e56d9163c863"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")
    dtm_pid = fork do
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    assert_match "succeed", shell_output("#{bin}/dtm-qs 2>&1")
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
