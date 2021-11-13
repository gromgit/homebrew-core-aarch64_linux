class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.11/IGV_2.11.3.zip"
  sha256 "38d97d319313f3d3d0da40f2c751708aaa47e58ca88718f8fcf47f18abfdcb48"
  license "MIT"

  livecheck do
    url "https://software.broadinstitute.org/software/igv/download"
    regex(/href=.*?IGV[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bca9700f55959cc195610c67dd83fd6644c2ac8966d90df476113d3793414b9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "bca9700f55959cc195610c67dd83fd6644c2ac8966d90df476113d3793414b9b"
    sha256 cellar: :any_skip_relocation, catalina:      "bca9700f55959cc195610c67dd83fd6644c2ac8966d90df476113d3793414b9b"
    sha256 cellar: :any_skip_relocation, mojave:        "bca9700f55959cc195610c67dd83fd6644c2ac8966d90df476113d3793414b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977f5d66ce9c94de6648ac1c71006de38da3d912495598b178e0ccad35a53ceb"
    sha256 cellar: :any_skip_relocation, all:           "5db8b9741ae2a714546427260cc426d89d45018f7abe0b400f9acd121506d38d"
  end

  depends_on "openjdk"

  def install
    inreplace ["igv.sh", "igvtools"], /^prefix=.*/, "prefix=#{libexec}"
    bin.install "igv.sh" => "igv"
    bin.install "igvtools"
    libexec.install "igv.args", "lib"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/igvtools")
    assert_match "org/broad/igv/ui/IGV.class", shell_output("#{Formula["openjdk"].bin}/jar tf #{libexec}/lib/igv.jar")

    ENV.append "_JAVA_OPTIONS", "-Duser.home=#{testpath}"
    (testpath/"script").write "exit"
    assert_match "Version", shell_output("#{bin}/igv -b script")
  end
end
