class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.17.1.tar.gz"
  sha256 "29fc5ec6250333e8ce60e922d08539ca236ca8286ad3b416242c9c1a469a2733"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "333a18dff7574ff3cdec3c92affecc3f9916227c6acea449e1e34e57aaaced24" => :big_sur
    sha256 "7bc9e6833bd29fe41a567bc864a42556f86aae362ce114992f5cde60af607674" => :catalina
    sha256 "4bbfb7c84b985fc437b09fb1a03a8366ff6587d4f4ebf130847728047ea6e4fb" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
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
