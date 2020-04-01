class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.41.0.tar.gz"
  sha256 "e9209b57eab6c944e9831c98dde11335c901e17c79196ea09d88b85b9047d9ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "6aca757d1324fd7343c1d35b6bdfd4404fd30ce84a2585baad2bbb24fcd4fd65" => :catalina
    sha256 "9967378e0220917c3a54caa782789945417c2f61e2cd4c1167634c3573c41411" => :mojave
    sha256 "e2532ec144d35ef1759e0efcad6dc846d29bba697d462c150eaea32c2bab98ad" => :high_sierra
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
