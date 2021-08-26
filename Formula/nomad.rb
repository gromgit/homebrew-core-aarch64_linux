class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.3.tar.gz"
  sha256 "18eb2b7fcd4d32952546b3d8b052e755dedc4c63e36527404db6abdce01b197d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db6c25639eac0557f096c37b6b9d8cdd68cab96adeecdfe1eb65f208f41338bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b05b917151393292c34bde5dba2d0199eb4eae1841b8c96400b51b6dbb47867"
    sha256 cellar: :any_skip_relocation, catalina:      "a1ced2e22652fada1854cf0d9173c11ed09d3a3e6eaf1fdee71668727ec86ba1"
    sha256 cellar: :any_skip_relocation, mojave:        "8d248ab4bbcf26fc7581f236b8f26a7b63f9f6c2ffff5eeaffe1d8c4a5f627ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4751a369be0a21babf0578081ce9962738dd6a780d648af50cc9b42ef3ba08c0"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/hashicorp/nomad/commit/5f5ec95282f4f3392562d1dd39d4f12cdbc72a82.patch?full_index=1"
    sha256 "4c757ca650b71878390b6aaea1823482ae8196e0afaca6e72f4b65a626eb4e09"
  end

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
