class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.3.2.tar.gz"
  sha256 "239e76615c17b45a3e92ead8e71ce5e4575beded0874731544a72e2038b5a5fc"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7104e273c9594a35670604d3292fd670360124281b04b24eaa16991c7ae3875f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2efeb8883e5b857a9112c61a988aac243fbaacb76572532f709fd390deb9a2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "97d98f44b6f25cc8d8b01137d8807030dcb4f7f87f95c6e1ef65b2fb4952961e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b8454567292a7b503515719abd2ba99222fc398a1f2152a41bfd8224d416cf2"
    sha256 cellar: :any_skip_relocation, catalina:       "db97f8074af24166cc7aac4c079337a66d3d6e0d6be253236754e7225157eb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2edd20e9cd376907d63ff9dd4e351aba5e623238cc4367b4eeee09221e9a38c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "ui"
  end

  service do
    run [opt_bin/"nomad", "agent", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
