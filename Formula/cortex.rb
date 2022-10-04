class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.13.1.tar.gz"
  sha256 "aa742a608c8201fcca41061cd2264d1b8eebe61c22259a5289de3a226aeee7e3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dfca8da82187967a67b216a66e3dec108a49d960b1b196f84573e020ec891c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cc421fa507124025e0021b09bfa1dfa88ceb0c422616bba3f999b006ccd8bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "284161f629fd7630cb356600a924783129802f2e19c944f13bbc48628d626334"
    sha256 cellar: :any_skip_relocation, big_sur:        "71243b44ec33c215147ea74df1069e45fd85904228b1536c751f7767211e7625"
    sha256 cellar: :any_skip_relocation, catalina:       "3c497ef2de9d0854ec36b3e44171dee72c8d51eeb8008ce1f905480370ff7495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3dfc6e434747b285dfdc903c1e8ac9d6dce94ab1055b28510997ce84caecb23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cortex"
    cd "docs/chunks-storage" do
      inreplace "single-process-config.yaml", "/tmp", var
      etc.install "single-process-config.yaml" => "cortex.yaml"
    end
  end

  service do
    run [opt_bin/"cortex", "-config.file=#{etc}/cortex.yaml"]
    keep_alive true
    error_log_path var/"log/cortex.log"
    log_path var/"log/cortex.log"
    working_dir var
  end

  test do
    port = free_port

    cp etc/"cortex.yaml", testpath
    inreplace "cortex.yaml" do |s|
      s.gsub! "9009", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"cortex", "-config.file=cortex.yaml", "-server.grpc-listen-port=#{free_port}" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/services")
    assert_match "Running", output
  end
end
