class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.0.1.tar.gz"
  sha256 "206b999c383cb37f4cc26a039decf56725b07a6e9e5c99ee7cab3f2fae255a5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ab08928a8fdaf86e93c4b72b3fb4f7d8ff4629b7a5a758bb057e5d9f5b426ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3bc1313727675be07b133cf951ecd17a21b622ea84ad59395b206b94c38e681"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b00d1bf495cc870a619ea103fe0e9566fc67a9482f09739b5236de9f6309d8"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef3f12ed4b7fa6e324ec97ef990ffc38df7a49032512cbb98a2ae743220206b"
    sha256 cellar: :any_skip_relocation, big_sur:        "35fcaafd8835cd87e43b5faeb974eed0db4b1871b159547a647826c8fdc47e5a"
    sha256 cellar: :any_skip_relocation, catalina:       "4a345fa916bde56ef06f2f0878d9cc807619f43b480cc16c57884cc8a0d9cca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a6f012c2cbcce5af11d2fe09b9981bfe9ed53bccf9dfabcbf66e0749ce7fd2"
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
