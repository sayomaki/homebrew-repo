class DbusTestRunner < Formula
  desc "Small little utility to run executables under a new DBus session for testing"
  homepage "https://launchpad.net/dbus-test-runner"
  url "https://launchpad.net/dbus-test-runner/19.04/19.04.0/+download/dbus-test-runner-19.04.0.tar.gz"
  sha256 "645a32fbd909baf2c01438f0cbda29dc9cd01a7aba5504c45610d88e8a57cb76"
  license "GPL-3.0-only"

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "dbus-glib"
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal which("dbus-test-runner"), HOMEBREW_PREFIX/"bin/dbus-test-runner"
    assert_match "dbus-test-runner", shell_output("#{bin}/dbus-test-runner -h")
  end
end
