class Apgdiff < Formula
  desc "Another PostgreSQL diff tool"
  homepage "https://www.apgdiff.com/"
  url "https://github.com/fordfrog/apgdiff/archive/refs/tags/release_2.7.0.tar.gz"
  sha256 "932a7e9fef69a289f4c7bed31a9c0709ebd2816c834b65bad796bdc49ca38341"
  license "MIT"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/apgdiff"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bbf03a4049337fc1e304c24d66ba326b4e401a3096f5415b0946ae9d3f8b06a0"
  end


  head do
    url "https://github.com/fordfrog/apgdiff.git", branch: "develop"
    depends_on "ant" => :build
  end

  depends_on "openjdk"

  def install
    jar = "releases/apgdiff-#{version}.jar"

    if build.head?
      system "ant", "-Dnoget=1"
      jar = Dir["dist/apgdiff-*.jar"].first
    end

    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "apgdiff"
  end

  test do
    sql_orig = testpath/"orig.sql"
    sql_new = testpath/"new.sql"

    sql_orig.write <<~EOS
      SET search_path = public, pg_catalog;
      SET default_tablespace = '';
      CREATE TABLE testtable (field1 integer);
      ALTER TABLE public.testtable OWNER TO fordfrog;
    EOS

    sql_new.write <<~EOS
      SET search_path = public, pg_catalog;
      SET default_tablespace = '';
      CREATE TABLE testtable (field1 integer,
        field2 boolean DEFAULT false NOT NULL);
      ALTER TABLE public.testtable OWNER TO fordfrog;
    EOS

    expected = <<~EOS.strip
      ALTER TABLE testtable
      \tADD COLUMN field2 boolean DEFAULT false NOT NULL;
    EOS

    result = pipe_output("#{bin}/apgdiff #{sql_orig} #{sql_new}").strip

    assert_equal result, expected
  end
end
