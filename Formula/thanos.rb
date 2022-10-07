class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.28.1.tar.gz"
  sha256 "e00ae14b88b9a3ae6b1ae022a0bd4fad34fd2da401bcef401cefa5e087675783"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba0227c5080516d799fdc9a760a4caf154f42c8f4a0e4c3303e70f1cb45a3eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "021b8c531e15b3ef3e765d8ac856637f83353eaf472b62b1aec3b75e8b841df7"
    sha256 cellar: :any_skip_relocation, monterey:       "1d527d2229e736a328cc778a2bbfff3958c53a884f57f397704e156334f60e45"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7eef2a300371308dfb3601e081c7a99829c68e54144f601ef8f2e18faedcea3"
    sha256 cellar: :any_skip_relocation, catalina:       "d76354b98e19342abfa2fa069464a9d9efb27c50f00ece8dd6291a66f05ae369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8ed8202f63a2fc6caf8f97c13f19a6c628662f6b7d15562ffb29fb54217210f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
