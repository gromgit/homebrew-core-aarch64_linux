class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.13",
      revision: "2c2214baf6b016ded184373252cff16bb377d3c0"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aliddns"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "be0e752f57124640b05e7a54786810d845a78e5e9a0a307f60efd11add2a1e3c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
    pkgetc.install "aliddns.yaml"
  end

  service do
    run [opt_bin/"aliddns", "-c", etc/"aliddns/aliddns.yaml"]
    keep_alive true
    log_path var/"log/aliddns.log"
    error_log_path var/"log/aliddns.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aliddns -v 2>&1")
    assert_match "config created", shell_output("#{bin}/aliddns init --config=aliddns.yml 2>&1")
    assert_predicate testpath/"aliddns.yml", :exist?
  end
end
