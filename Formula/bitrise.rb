class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.49.3.tar.gz"
  sha256 "6af2f55c08a99412af6fc2dfe439515ef7dc666a91eebe10632b496e8c4f9d63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92ec553ca72b8b6c61ba329205c925512f5ae3c61398c264f04d45a31e687a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c76d809c77c0a290f818f1295ae5d9aef15956a0e68037c4f3686283660ccb6"
    sha256 cellar: :any_skip_relocation, monterey:       "67c47ca1ef9e987ea670838b9dbbd58f4a51ccc9e91fa0445e3d65b63105a105"
    sha256 cellar: :any_skip_relocation, big_sur:        "9af591c69ae0023355920dd3ce5258e41636b680277cd00377f2e0a6ecdd1bce"
    sha256 cellar: :any_skip_relocation, catalina:       "13a6548e9ff121ce8e22dc73249a5091f3b00b4db4fea3759ba42933d6edc1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d303e1b4b0776b2a9fa4ff81bb50428626c1f5289d572c79b1d8078843554a"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
