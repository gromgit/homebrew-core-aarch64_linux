class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.00.tar.gz"
  sha256 "fa5be8f54a5f4c6b7031847538701479426bdbffc86b7ed7f419308a0d21a28f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eb5b06b552ebb6d629173fccc1edf71f9acf76df31b72a6c58d33f7b87deba0b"
    sha256 cellar: :any,                 arm64_big_sur:  "eafbde7dfefd35d93b8293034f4148766c44f122d5dd972ad65c79aeacb088e1"
    sha256 cellar: :any,                 monterey:       "15186c2f1b5056000c57a26abd92a57750e95a724e7cde82c2b5684c544f6267"
    sha256 cellar: :any,                 big_sur:        "91454839e82d4223153b97a1536d3931b2eebf2125541f7123c98c057af067b4"
    sha256 cellar: :any,                 catalina:       "0ee4598f3a27d5bb1fb8cfe2ea68b31a57e4d48ddbdf2909b72e1486f6fe6002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5766c254237c4b387fa3aee3d682773ef458eca3d342ca8d34a7246a42b9ee02"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[current jni resources]
    libexec.install Dir["*.sh"]
    bin.install Dir[libexec/"*.sh"]
    bin.env_script_all_files(libexec, Language::Java.overridable_java_home_env)
    doc.install Dir["docs/*"]
  end

  test do
    res = libexec/"resources"
    args = %W[in=#{res}/sample1.fq.gz
              in2=#{res}/sample2.fq.gz
              out=R1.fastq.gz
              out2=R2.fastq.gz
              ref=#{res}/phix174_ill.ref.fa.gz
              k=31
              hdist=1]
    system "#{bin}/bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
