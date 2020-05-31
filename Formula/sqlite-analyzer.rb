class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2020/sqlite-src-3320100.zip"
  version "3.32.1"
  sha256 "5ccc7dd634ab820dbcef56318279d27ee945ccaba17e70d4932e5c624a7872d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3517214cae1e17894cc06169bdaf4a03dfb4ef6ff7ccb61fa32480f6f48e6c5" => :catalina
    sha256 "be405bc4078118746a51b5b80c8b339a05db8886f7d865269840af5bad01996a" => :mojave
    sha256 "f94630bc01b6bb5060b9c2cfd887d01096388436dd51fa1259e4d202153da4b5" => :high_sierra
  end

  def install
    sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
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
