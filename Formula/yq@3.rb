class YqAT3 < Formula
  desc "Process YAML documents from the CLI - Version 3"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.1.tar.gz"
  sha256 "73259f808d589d11ea7a18e4cd38a2e98b518a6c2c178d1ec57d9c5942277cb1"
  license "MIT"

  keg_only :versioned_formula

  disable! date: "2021-08-01", because: :unmaintained

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args, "-o", bin/"yq"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
