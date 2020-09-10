class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.15.0.tar.gz"
  sha256 "f64321e0e8f7f9a485956dadabf11c305dc4a1a5f40693fbeb5aea8b5862faad"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "06732f3355bdbcb985641bf05fc25b6c00e8cc3eec3577b4ec144770412b23ff" => :catalina
    sha256 "2c091e795f8cd556188dfb64ff989b57fb727b8c7fd27adff832b9f6899a5d71" => :mojave
    sha256 "9c0abdf3859ed78918d98a67eab5cf49a4dff8ea42d3788e1f8cbc5cda04c54a" => :high_sierra
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
