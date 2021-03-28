class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2021/sqlite-src-3350300.zip"
  version "3.35.3"
  sha256 "4ca1dff5578b1720061dd4452f91a5c3eced5ba3773354291d9aee9e2796a720"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7ce1b6b5e65f146261cc11d3104ea38070e42bf96b51998d50e5576e0ac2749"
    sha256 cellar: :any_skip_relocation, big_sur:       "512191b5c3ca145bab8daab7407826b3ff6ff843b1c9a5bfa8133e6f1a749b35"
    sha256 cellar: :any_skip_relocation, catalina:      "d78a7067cdb519c7fd1bdb450173fc5549ba4cd01c16f64618aaa64b3843b6cf"
    sha256 cellar: :any_skip_relocation, mojave:        "65c16d45b0afc3bd942cd1b69728bd1db83942e1593218b2a329a0cda7bb4e61"
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed
    system "./configure", "--disable-debug",
                          "--with-tcl=#{sdkprefix}/System/Library/Frameworks/Tcl.framework/",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
