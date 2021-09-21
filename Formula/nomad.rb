class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.5.tar.gz"
  sha256 "7faa2e395ccbe53f5c2200b3ff8ace1430ae30e95f3a6c9673898413899eeda7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2241dc1516043457e81cdecc110a3c901c358327d6cbba15eb510971df1039a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a2b7842b522a4bde03bf7c15de5cb6f007b881226f73d41dbe152ad1d6f6bf9"
    sha256 cellar: :any_skip_relocation, catalina:      "2a8b0b54f049f2bb75536d6c1215ac5f9b183aa926afa66cb78eae390f08a4b7"
    sha256 cellar: :any_skip_relocation, mojave:        "9bd4472c8ded1863bc7d40df4232ea92f8970a14b2425ae679af013cf18aba77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec0d18c2c691ef41acbd87dc8ac4788f64b4931480494acae64a2c1bc724e00"
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
