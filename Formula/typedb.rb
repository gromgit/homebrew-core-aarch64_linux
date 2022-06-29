class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.11.1/typedb-all-mac-2.11.1.zip"
  sha256 "72f32ed4cc4a5e733fa8550d528a3c0e525312fe92df1fb9a28e5e69fc9a3d6f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7860bda62436d9b5cdca6e18ea1f2d4a70fbee8360f26f2c65f23ec27a59a1a7"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
