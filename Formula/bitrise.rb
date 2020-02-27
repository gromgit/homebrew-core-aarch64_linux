class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.39.1.tar.gz"
  sha256 "6b4758927907a57b5ceb46f74a97481fcfafff12f634cc336877bb97b69602a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "05ae35055e3914b57f1a47f6ffa3345b5035d869d28e02f090e2903cdf917d08" => :catalina
    sha256 "105779fed99609d51a8bdb9d32d447f8084f02d865d575af694d9d50801f490c" => :mojave
    sha256 "63b5599e1ab68a99bd628950e195f72be55c34bf2bc56772ca7f74447bbfdd81" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      prefix.install_metafiles

      system "go", "build", "-o", bin/"bitrise"
    end
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
