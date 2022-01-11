class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e3dc74cafdc3c290da6636036861ee2f7b8b1e9e7447a3a9f21b53a20a5bd980"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78dde7e5c92334ff304bd345b96671041ca8578c8fc956d62ac0c8269d8a7d11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "983bf30f3bfb7ba324d3edd44a65558de4d7e8bacafb27fecf722cb0064f3d42"
    sha256 cellar: :any_skip_relocation, monterey:       "5cbc803e1c7f906142deb2f04a1c6d3dc8479317daf90d701af40038118a2321"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff4eab0cc2516cc2110848178d7d32a96e2b9a7674b8e8b5c8042b7506e68843"
    sha256 cellar: :any_skip_relocation, catalina:       "3ffcf27abec100d5d2c822e898b0be4dac8479a5b60e9b603f37f8b142be71a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b9f61ac91b44752fcf2c69d534a4bcc4ae4a7665d8a64fdb2aefdb2c7d1f51c"
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
