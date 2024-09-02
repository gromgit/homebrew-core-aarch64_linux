class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.0.0/apache-opennlp-2.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.0.0/apache-opennlp-2.0.0-bin.tar.gz"
  sha256 "5a37903c286cd2bd6b769d965ec785f0a2e1a597323bb6123f15ea14d0097f6c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/apache-opennlp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "09c10aa48f2d9911efe249bf3a6e64fbb275fa9913d0a44f47d3a3da3f681989"
  end


  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
