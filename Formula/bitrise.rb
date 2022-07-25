class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.49.1.tar.gz"
  sha256 "e6cc5ab323f66d1c16d498aea7cd4f4d95c1389bec38568cc3dc2ea575508760"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebf4724e904a9323fc57571f3d79b929bc4265f29170f0f6e3e22355895f7fad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43039620ea239b67378ef9f54392eda3403a291a6e4597a0b0761db0e3f92a42"
    sha256 cellar: :any_skip_relocation, monterey:       "689747538a065f967576577fe3875d2f9008229d88a6f1ab48fe8c530c1ab330"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca820ac55c547f5364c0628294643be8d441d0ddfba79ff48952a2f8693509de"
    sha256 cellar: :any_skip_relocation, catalina:       "436af0c8446863fc5e35da1edcb6e1a7f4cde95352bc23fdd98aec2498b33e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6086fed89ed83fab53ddc6b3b6ce58c3fa6e8c117fab9955a9232b04a2d2e547"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
