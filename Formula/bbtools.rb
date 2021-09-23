class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.93.tar.gz"
  sha256 "e2700cc6bfa6ff0868bb2887850f1e514bc6e44cd71ca933e23ae5ce3c630605"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d48cb8fda86fc26b8743176a105d971a93fcf6d9c104e17da711af9431176e8b"
    sha256 cellar: :any,                 big_sur:       "c58e0dd12480d053b2773d379595113306413a1232b8e6f06c16a21200336910"
    sha256 cellar: :any,                 catalina:      "55871cc98ba20e53a2719d19db44914b0805087b1a07d35dfe3416c34d8a5560"
    sha256 cellar: :any,                 mojave:        "2f4d3beb9b4a22f244efd09fe6f0fcb3e0fce712e2b82047cf884559a0d65fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ede7fab3159235bc54da642e9e7f97e5d99c26edcd9700abf9a3b8a9aed71a"
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
