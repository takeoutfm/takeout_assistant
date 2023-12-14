# Copyright 2023 defsub
#
# This file is part of Takeout.
#
# Takeout is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# Takeout is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for
# more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Takeout.  If not, see <https://www.gnu.org/licenses/>.

VERSION = $(shell cat .version)

RELEASE_APK = build/app/outputs/flutter-apk/app-release.apk

RELEASE_AAB = build/app/outputs/bundle/release/app-release.aab

ASSETS = ./assets

.PHONY: all release assets

all:
	${MAKE} --directory=assistant all

release:
	${MAKE} --directory=assistant release

bundle:
	${MAKE} --directory=assistant bundle

clean:
	rm -rf ${ASSETS}
	${MAKE} --directory=assistant clean

tag:
	git tag --list | grep -q v${VERSION} || git tag v${VERSION}
	git push origin v${VERSION}

version:
	scripts/version.sh #&& git commit -a

assets:
	@mkdir -p ${ASSETS}
	@cp assistant/${RELEASE_APK} ${ASSETS}/com.takeoutfm.assistant-${VERSION}.apk || true
	@cp assistant/${RELEASE_AAB} ${ASSETS}/com.takeoutfm.assistant-${VERSION}.aab || true
